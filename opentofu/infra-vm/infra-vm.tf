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

resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_20250117" {
  checksum           = "63f5e103195545a429aec2bf38330e28ab9c6d487e66b7c4b0060aa327983628"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-24.04-server-20250117-cloudimg-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/noble/20250117/noble-server-cloudimg-amd64.img"
}

# resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_minimal_latest" {
#   checksum           = "c4f9e677e3ff2f09c7f3bf17fef0ae76a9a6b3249b91d89e2b32c6f9ee1c97ed"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local-nvme-vm"
#   file_name          = "ubuntu-24.04-server-minimal-cloudimg-amd64.img"
#   node_name          = "miniquarium"
#   upload_timeout     = 180
#   url                = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
# }

# resource "proxmox_virtual_environment_download_file" "debian12_cloudimg_latest" {
#   checksum           = "340cdafca262582e2ec013f2118a7daa9003436559a3e1cff637af0fc05d4c3755d43e15470bb40d7dd4430d355b44d098283fc4c7c6f640167667479eeeb0e0"
#   checksum_algorithm = "sha512"
#   content_type       = "iso"
#   datastore_id       = "local-nvme-vm"
#   file_name          = "debian-12-cloudimg-amd64.img"
#   node_name          = "miniquarium"
#   upload_timeout     = 180
#   url                = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
# }

locals {
  disk_image_map = {
    # archlinux        = proxmox_virtual_environment_download_file.archlinux_cloudimg_latest.id
    # debian12           = proxmox_virtual_environment_download_file.debian12_cloudimg_latest.id
    # ubuntu22         = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest.id
    ubuntu24 = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_20250117.id
    # ubuntu22_minimal = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest.id
    # ubuntu24_minimal = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest.id
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    # proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    # proxmox_virtual_environment_download_file.debian12_cloudimg_latest,
    # proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest,
    # proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest,
    proxmox_virtual_environment_download_file.ubuntu24_cloudimg_20250117,
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
    datastore_id      = each.value.disk_efi_datastore
    pre_enrolled_keys = false
    type              = "4m"
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
    floating  = each.value.ram
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

  tpm_state {
    datastore_id = "local-nvme-vm"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = "local-nvme-vm"
  node_name    = "miniquarium"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  for_each = var.user_cloud_config

  content_type = "snippets"
  datastore_id = "local-nvme-vm"
  node_name    = "miniquarium"

  source_file {
    path      = each.value.user_data_path
    file_name = "${each.key}_ci_user-data.yml"
  }
}
