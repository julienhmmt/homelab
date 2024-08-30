# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password" {
  for_each         = var.vm
  length           = 24
  override_special = "_%@"
  special          = true
}

output "vm_root_password" {
  value     = { for key, pwd in random_password.vm_root_password : key => pwd.result }
  sensitive = true
}

# location of containers templates
resource "proxmox_virtual_environment_download_file" "ubuntu_cloudimg_latest" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "noble-server-cloudimg-amd64.img"
  node_name    = "pve1"
  overwrite    = true
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  depends_on = [
    proxmox_virtual_environment_download_file.ubuntu_cloudimg_latest,
    proxmox_virtual_environment_file.meta_cloud_config,
    proxmox_virtual_environment_file.cloud_config,
    random_password.vm_root_password
  ]

  for_each = var.vm

  bios                = "ovmf"
  description         = each.value.description
  keyboard_layout     = "fr"
  machine             = "q35"
  migrate             = true
  name                = each.value.hostname
  node_name           = "pve1"
  on_boot             = each.value.start_on_boot
  pool_id             = each.value.pool_id
  scsi_hardware       = "virtio-scsi-single"
  started             = each.value.started
  stop_on_destroy     = true
  tablet_device       = false
  tags                = each.value.tags
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = each.value.vm_id

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  audio_device {
    enabled = false
  }

  cpu {
    architecture = "x86_64"
    cores        = each.value.cpu_cores
    sockets      = 1
    type         = "host"
  }

  disk {
    cache        = "none"
    datastore_id = "local-zfs"
    discard      = "on"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloudimg_latest.id
    iothread     = true
    interface    = "scsi0"
    size         = each.value.disk_size
  }

  efi_disk {
    datastore_id = "local-zfs"
    type         = "4m"
  }

  initialization {
    datastore_id = "local-zfs"

    dns {
      domain  = "khepri.internal"
      servers = ["192.168.1.2"]
    }

    ip_config {
      ipv4 {
        address = each.value.ipv4_address
        gateway = "192.168.1.254"
      }
      ipv6 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[each.key].id
  }

  memory {
    dedicated = each.value.ram
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = each.value.firewall_enabled
    mac_address = each.value.net_mac_address
    rate_limit  = each.value.net_rate_limit
  }

  operating_system {
    type = "l26"
  }

  startup {
    order      = each.value.startup_order
    up_delay   = 60
    down_delay = 60
  }

  serial_device {}
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.cloud_config_metadata

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve1"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  for_each = var.cloud_config_scripts

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve1"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_user-data.yml"
  }
}
