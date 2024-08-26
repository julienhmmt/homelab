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
resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg_latest" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "Arch-Linux-x86_64-cloudimg.qcow2.img"
  node_name    = "pve1"
  overwrite    = true
  url          = "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
}

resource "proxmox_virtual_environment_vm" "archlinux_vm" {
  depends_on = [
    proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    proxmox_virtual_environment_file.cloud_config,
    random_password.vm_root_password
  ]

  for_each = var.vm

  bios                = "ovmf"
  description         = each.value.description
  keyboard_layout     = "fr"
  name                = each.value.hostname
  node_name           = "pve1"
  machine             = "q35"
  migrate             = true
  on_boot             = each.value.start_on_boot
  pool_id             = each.value.pool_id
  started             = each.value.started
  stop_on_destroy     = true
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
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.archlinux_cloudimg_latest.id
    interface    = "scsi1"
    discard      = "on"
  }

  efi_disk {
    datastore_id = "local-zfs"
    type         = "4m"
  }

  initialization {
    datastore_id = "local-zfs"
    interface    = "scsi0"

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

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
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
