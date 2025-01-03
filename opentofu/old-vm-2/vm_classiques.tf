# resource "proxmox_virtual_environment_download_file" "talos_cp_dodge" {
#   count          = var.hostname == "dodge" ? 1 : 0
#   content_type   = "iso"
#   datastore_id   = "local-nvme-vm"
#   file_name      = "talos-v1.9.1-cp-dodge.qcow2.img"
#   node_name      = "miniquarium"
#   upload_timeout = 180
#   url            = "https://factory.talos.dev/image/776c6d4971c72228b0572e9f52c549be03cabaa3e5a58d4f592585d4626fa9a2/v1.9.1/metal-amd64.qcow2"
# }

# resource "proxmox_virtual_environment_download_file" "talos_wkr_ram" {
#   count          = var.hostname == "ram" ? 1 : 0
#   content_type   = "iso"
#   datastore_id   = "local-nvme-vm"
#   file_name      = "talos-v1.9.1-wkr-ram.qcow2.img"
#   node_name      = "miniquarium"
#   upload_timeout = 180
#   url            = "https://factory.talos.dev/image/08c75417620b13358cb335763cd2cfb650105b69a4ace678e21fda66ab18b555/v1.9.1/metal-amd64.qcow2"
# }

# resource "proxmox_virtual_environment_download_file" "talos_wkr_viper" {
#   count          = var.hostname == "viper" ? 1 : 0
#   content_type   = "iso"
#   datastore_id   = "local-nvme-vm"
#   file_name      = "talos-v1.9.1-wkr-viper.qcow2.img"
#   node_name      = "miniquarium"
#   upload_timeout = 180
#   url            = "https://factory.talos.dev/image/92a068ffab7963732e0427ae609517ed71ab73fd85be0141c9676d1816c8dae5/v1.9.1/metal-amd64.qcow2"
# }

# resource "proxmox_virtual_environment_download_file" "talos_iso" {
#   count          = var.create_file ? 1 : 0
#   content_type   = "iso"
#   datastore_id   = "local-nvme-vm"
#   file_name      = "talos-v1.9.1.iso"
#   node_name      = "miniquarium"
#   upload_timeout = 180
#   url            = "https://factory.talos.dev/image/698322b7ce860b1f034de6bc66315576c3b957ceff0934c8120891753f68de82/v1.9.1/metal-amd64.iso"
# }

data "terraform_remote_state" "cloudimg" {
  backend = "local"
  config = {
    path = "../cloudimg/terraform.tfstate"
  }
}

locals {
  disk_image_map = {
    # talos_cp_dodge   = var.hostname == "dodge" ? "${proxmox_virtual_environment_download_file.talos_cp_dodge[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_cp_dodge[0].file_name}" : null
    # talos_wkr_ram    = var.hostname == "ram" ? "${proxmox_virtual_environment_download_file.talos_wkr_ram[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_wkr_ram[0].file_name}" : null
    # talos_wkr_viper  = var.hostname == "viper" ? "${proxmox_virtual_environment_download_file.talos_wkr_viper[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_wkr_viper[0].file_name}" : null
    # talos = var.create_file ? "${proxmox_virtual_environment_download_file.talos[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos[0].file_name}" : null
    # talos = "${proxmox_virtual_environment_download_file.talos_iso[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_iso[0].file_name}"
    # talos = var.create_file && length(proxmox_virtual_environment_download_file.talos_iso) > 0 ? "${proxmox_virtual_environment_download_file.talos_iso[0].datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_iso[0].file_name}" : null
    # ubuntu22         = data.terraform_remote_state.cloudimg.outputs.ubuntu22_cloudimg_latest_file_id
    # ubuntu22_minimal = data.terraform_remote_state.cloudimg.outputs.ubuntu22_minimal_cloudimg_latest_file_id
    ubuntu24 = data.terraform_remote_state.cloudimg.outputs.ubuntu24_cloudimg_latest_file_id
    # ubuntu24_minimal = data.terraform_remote_state.cloudimg.outputs.ubuntu24_minimal_cloudimg_latest_file_id
  }
}

resource "proxmox_virtual_environment_vm" "vm_classique" {
  for_each = !var.talos_vm ? [0] : []
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
    datastore_id = var.disk_vm_datastore
    interface    = "scsi0"
    size         = var.disk_size
    file_id      = local.disk_image_map[var.disk_vm_img]
    aio          = "native"
    cache        = "none"
    discard      = "on"
    iothread     = true
    replicate    = false
  }

  # disk {
  #   aio          = "native"
  #   cache        = "none"
  #   datastore_id = var.disk_vm_datastore # 'local-nvme-vm'
  #   discard      = "on"
  #   file_id      = local.disk_image_map[var.disk_vm_img]
  #   iothread     = true
  #   interface    = "scsi0"
  #   replicate    = false
  #   size         = var.disk_size
  # }

  dynamic "efi_disk" {
    for_each = var.disk_efi_creation ? [1] : []

    content {
      datastore_id = var.disk_efi_creation ? var.disk_efi_datastore : null
      type         = "4m"
    }
  }

  initialization {
    datastore_id = var.disk_vm_datastore

    dns {
      domain  = var.domain
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = var.ipv4
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config[each.key].id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config[each.key].id
  }

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

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.talos_vm && length(try(var.user_cloud_config, {})) > 0 ? var.user_cloud_config : {}

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = each.value.meta_data
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  for_each = var.talos_vm && length(try(var.user_cloud_config, {})) > 0 ? var.user_cloud_config : {}

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_file {
    path      = each.value.user_data_path
    file_name = "${each.key}_ci_user-data.yml"
  }
}
