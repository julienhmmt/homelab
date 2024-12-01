# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
# resource "random_password" "vm_root_password" {
#   for_each         = var.vm
#   length           = 24
#   override_special = "_%@"
#   special          = true
# }

# output "vm_root_password" {
#   value     = { for key, pwd in random_password.vm_root_password : key => pwd.result }
#   sensitive = true
# }

resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg_latest" {
  #checksum           = "7751dda44d5e5daa2d6b6a73957b0b9a4e41cbde6d6cb29fcff672b5d54133e2"
  #checksum_algorithm = "sha256"
  content_type   = "iso"
  datastore_id   = "local"
  file_name      = "archlinux-latest-cloudimg-amd64.img"
  node_name      = "proxmox"
  upload_timeout = 180
  url            = "https://geo.mirror.pkgbuild.com/images/v20241001.267073/Arch-Linux-x86_64-basic.qcow2"
}
resource "proxmox_virtual_environment_download_file" "debian_cloudimg_202411" {
  checksum           = "9792c2c5dfdb796fd7caaf0e56f61e356b36eb76032f453515072ad9e517930d55d2e6705a4fea96a2413a656e4561eb018c52bdf4f24cd88b02d19e9daad76b"
  checksum_algorithm = "sha512"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "debian-latest-cloudimg-amd64.img"
  node_name          = "proxmox"
  upload_timeout     = 180
  url                = "https://cloud.debian.org/images/cloud/bookworm/20241125-1942/debian-12-genericcloud-amd64-20241125-1942.qcow2"
}
resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_minimal_latest" {
  checksum           = "a426bbf3c64132d022792cafbf50d965b0fd8d68dd33b45eb96e327e8abb857c"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-22.04-server-minimal-cloudimg-amd64.img"
  node_name          = "proxmox"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img"
}
resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_minimal_latest" {
  checksum           = "a5e583583782b9fa631165e5c66a53201fcabd58e5098424babee0674160fb54"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-24.04-server-minimal-cloudimg-amd64.img"
  node_name          = "proxmox"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
}
resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_latest" {
  checksum           = "0ba0fd632a90d981625d842abf18453d5bf3fd7bb64e6dd61809794c6749e18b"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-22.04-server-cloudimg-amd64.img"
  node_name          = "proxmox"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/jammy/20241004/jammy-server-cloudimg-amd64.img"
}
resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_latest" {
  checksum           = "5dc7f9c796442a51316d8431480fbe3f62cadbfde4d58a14d34dd987c01fd655"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-24.04-server-cloudimg-amd64.img"
  node_name          = "proxmox"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/noble/20241106/noble-server-cloudimg-amd64.img"
}

locals {
  disk_image_map = {
    archlinux        = proxmox_virtual_environment_download_file.archlinux_cloudimg_latest.id
    debian           = proxmox_virtual_environment_download_file.debian_cloudimg_202411.id
    ubuntu22         = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest.id
    ubuntu24         = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_latest.id
    ubuntu22_minimal = proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest.id
    ubuntu24_minimal = proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest.id
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    proxmox_virtual_environment_download_file.debian_cloudimg_202411,
    proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest,
    proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest,
    proxmox_virtual_environment_download_file.ubuntu24_cloudimg_latest,
    proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest,
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
  node_name           = "proxmox"
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
    datastore_id = each.value.disk_vm_datastore # 'zfsvm', 'nvme' si besoin de perfs, sinon 'local'
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
    for_each = each.value.hostname == "ups01" ? [1] : []
    content {
      mapping = "onduleur"
      usb3 = false
    }
  }
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  for_each = var.user_cloud_config

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"

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
