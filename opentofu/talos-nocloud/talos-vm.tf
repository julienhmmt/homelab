resource "proxmox_virtual_environment_vm" "talos_vm" {
  depends_on = [
    proxmox_virtual_environment_download_file.talos_nocloud_image,
    proxmox_virtual_environment_file.meta_cloud_config,
    # proxmox_virtual_environment_file.user_cloud_config_dodge
  ]
  for_each = var.nodes

  bios                = "seabios"
  description         = each.value.vm_description
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = each.value.vm_name
  node_name           = "miniquarium"
  on_boot             = true
  pool_id             = each.value.vm_pool_id
  scsi_hardware       = "virtio-scsi-single"
  started             = "true"
  stop_on_destroy     = true
  tablet_device       = false
  tags                = each.value.vm_tags
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
    cores   = each.value.vm_cpu_cores
    numa    = true
    sockets = 1
    type    = each.value.vm_cpu_type
  }

  disk {
    datastore_id = each.value.vm_datastore_id
    interface    = "scsi0"
    size         = each.value.vm_disk_size
    file_format  = each.value.vm_disk_format
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    aio          = "native"
    cache        = "none"
    discard      = "on"
    iothread     = true
    replicate    = false
  }

  dynamic "efi_disk" {
    for_each = each.value.vm_efi ? [1] : []
    content {
      datastore_id      = "zfs_nvme"
      file_format       = "raw"
      pre_enrolled_keys = false
      type              = "4m"
    }
  }

  initialization {
    datastore_id = "zfs_nvme"
    ip_config {
      ipv4 {
        address = each.value.vm_ip
        gateway = "192.168.1.254"
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  memory {
    dedicated = each.value.vm_memory_dedicated
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = false
    mac_address = each.value.vm_mac_address
    rate_limit  = each.value.vm_eth_rate_limit
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = each.value.vm_startup_order
    up_delay   = 15
    down_delay = 60
  }

  dynamic "tpm_state" {
    for_each = each.value.vm_tpm ? [1] : []
    content {
      datastore_id = "zfs_nvme"
      version      = "v2.0"
    }
  }

  vga {
    type = "virtio"
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

# resource "proxmox_virtual_environment_file" "user_cloud_config_dodge" {
#   for_each = var.user_cloud_config

#   content_type = "snippets"
#   datastore_id = "zfs_nvme"
#   node_name    = "miniquarium"

#   source_file {
#     path      = each.value.user_data_path
#     file_name = "${each.key}_ci_user-data.yml"
#   }
# }
