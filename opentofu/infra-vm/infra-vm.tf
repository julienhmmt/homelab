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

resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_latest" {
  checksum           = "e61484705035cd64d8e79c35d6f674acccf03ef9c6939ca50dea8a4fdc7eabeb"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-24.04-server-cloudimg-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

locals {
  disk_image_map = {
    # archlinux        = proxmox_virtual_environment_download_file.archlinux_cloudimg_latest.id
    # debian           = proxmox_virtual_environment_download_file.debian_cloudimg_202411.id
    # ubuntu22         = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest.id
    ubuntu24 = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_latest.id
    # ubuntu22_minimal = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest.id
    # ubuntu24_minimal = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest.id
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    # proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    # proxmox_virtual_environment_download_file.debian_cloudimg_202411,
    # proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest,
    # proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest,
    proxmox_virtual_environment_download_file.ubuntu24_cloudimg_latest,
    # proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest,
    proxmox_virtual_environment_file.meta_cloud_config,
    proxmox_virtual_environment_file.user_cloud_config
    # random_password.vm_root_password
  ]

  for_each = var.vm

  bios                = "seabios"
  description         = each.value.description
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = each.value.hostname
  node_name           = "miniquarium"
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

  cpu {
    cores   = each.value.cpu_cores
    numa    = true
    sockets = 1
    type    = "host"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = each.value.disk_vm_datastore
    discard      = "on"
    file_id      = local.disk_image_map[each.value.disk_vm_img]
    iothread     = true
    interface    = "scsi0"
    replicate    = false
    size         = each.value.disk_size
  }

  efi_disk {
    datastore_id = each.value.disk_efi_datastore
    type         = "4m"
  }

  initialization {
    datastore_id = each.value.disk_vm_datastore

    dns {
      domain  = each.value.domain
      servers = each.value.dns_servers
    }

    ip_config {
      ipv4 {
        address = each.value.ipv4
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config[each.key].id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config[each.key].id
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

  serial_device {}

  smbios {
    family       = "VM"
    manufacturer = "QEMU"
    product      = "virtio"
    version      = "1.0"
  }

  startup {
    order      = each.value.startup_order
    up_delay   = 15
    down_delay = 60
  }

  dynamic "usb" {
    for_each = each.value.hostname == "tesla" ? [1] : []
    content {
      mapping = "onduleur"
      usb3    = false
    }
  }
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  for_each = var.user_cloud_config

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_file {
    # path      = "cloud-init/${each.key}.yaml"
    path      = each.value.user_data_path
    file_name = "${each.key}_ci_user-data.yml"
  }
  # source_raw {
  #   data      = each.value
  #   file_name = "${each.key}_ci_user-data.yml"
  # }
}
