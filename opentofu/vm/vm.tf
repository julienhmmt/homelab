resource "proxmox_virtual_environment_download_file" "talos_cp_dodge" {
  count          = var.hostname == "dodge" ? 1 : 0
  content_type   = "iso"
  datastore_id   = "local-nvme-vm"
  file_name      = "talos-v1.9.1-cp-dodge.qcow2.img"
  node_name      = "miniquarium"
  upload_timeout = 180
  url            = "https://factory.talos.dev/image/7244f5d555a519a1071ddcd3c6ed82f7e758477108b0b5a4e506c67635d7f08e/v1.9.1/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "talos_wkr_ram" {
  count          = var.hostname == "ram" ? 1 : 0
  content_type   = "iso"
  datastore_id   = "local-nvme-vm"
  file_name      = "talos-v1.9.1-wkr-ram.qcow2.img"
  node_name      = "miniquarium"
  upload_timeout = 180
  url            = "https://factory.talos.dev/image/f48a9b37be2d65a3f91cdbee2ccd16f5369d49b7076ebaeb9e1b4957adb210e8/v1.9.1/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "talos_wkr_viper" {
  count          = var.hostname == "viper" ? 1 : 0
  content_type   = "iso"
  datastore_id   = "local-nvme-vm"
  file_name      = "talos-v1.9.1-wkr-viper.qcow2.img"
  node_name      = "miniquarium"
  upload_timeout = 180
  url            = "https://factory.talos.dev/image/0e533aa27c5fa7e6ab7c0794df7c15c5bb3d641f47e0b7e844e4964b6fdb004c/v1.9.1/metal-amd64.qcow2"
}

locals {
  disk_image_map = {
    talos_cp_dodge  = var.hostname == "dodge" ? "${proxmox_virtual_environment_download_file.talos_cp_dodge[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_cp_dodge[0].file_name}" : null
    talos_wkr_ram   = var.hostname == "ram" ? "${proxmox_virtual_environment_download_file.talos_wkr_ram[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_wkr_ram[0].file_name}" : null
    talos_wkr_viper = var.hostname == "viper" ? "${proxmox_virtual_environment_download_file.talos_wkr_viper[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_wkr_viper[0].file_name}" : null
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    #   proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    # data.terraform_remote_state.cloudimg
  ]

  bios                = "seabios"
  description         = var.description
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = var.hostname
  node_name           = "miniquarium"
  on_boot             = var.start_on_boot
  pool_id             = var.pool_id
  scsi_hardware       = "virtio-scsi-single"
  started             = var.started
  stop_on_destroy     = true
  tablet_device       = false
  tags                = var.tags
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = var.vm_id

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = var.cpu_cores
    numa    = true
    sockets = 1
    type    = "host"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = var.disk_vm_datastore # 'local-nvme-vm'
    discard      = "on"
    file_id      = local.disk_image_map[var.disk_vm_img]
    iothread     = true
    interface    = "scsi0"
    replicate    = false
    size         = var.disk_size
  }

  #   efi_disk {
  #     datastore_id = var.disk_efi_datastore
  #     type         = "4m"
  #   }

  #   initialization {
  #     datastore_id = var.disk_vm_datastore

  #     dns {
  #       domain  = var.domain
  #       servers = var.dns_servers
  #     }

  #     ip_config {
  #       ipv4 {
  #         address = var.ipv4
  #         gateway = "192.168.1.254"
  #       }
  #     }

  #     meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config.id
  #     user_data_file_id = proxmox_virtual_environment_file.user_cloud_config.id
  #   }

  memory {
    dedicated = var.ram
    floating  = var.ram_floating
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = var.firewall_enabled
    mac_address = var.net_mac_address
    rate_limit  = var.net_rate_limit
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = var.startup_order
    up_delay   = 15
    down_delay = 60
  }

  tpm_state {
    datastore_id = var.disk_vm_datastore
    version      = "v2.0"
  }
}
