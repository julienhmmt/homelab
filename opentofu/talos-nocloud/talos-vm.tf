resource "proxmox_virtual_environment_vm" "talos_vm" {
  depends_on = [
    # proxmox_virtual_environment_download_file.talos_nocloud_image,
    proxmox_virtual_environment_file.meta_cloud_config
  ]
  for_each = var.nodes

  acpi                = true
  bios                = "ovmf"
  description         = each.value.vm_description
  keyboard_layout     = "fr"
  kvm_arguments       = each.value.vm_kvm_args
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = each.value.vm_name
  node_name           = each.value.pve
  on_boot             = each.value.vm_on_boot ? true : false
  pool_id             = each.value.vm_pool_id
  scsi_hardware       = "virtio-scsi-single"
  started             = each.value.vm_started ? "true" : "false"
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
    flags   = each.value.vm_cpu_flags
    numa    = true
    sockets = 1
    type    = each.value.vm_cpu_type
  }

  disk { # boot disk
    aio          = "native"
    backup       = false
    cache        = "none"
    datastore_id = each.value.vm_datastore_id_boot_disk
    discard      = "on"
    file_format  = each.value.vm_boot_disk_format
    file_id      = "local:iso/talos-v1.9.4-nocloud-amd64.img"
    interface    = "scsi0"
    iothread     = true
    replicate    = false
    size         = each.value.vm_boot_disk_size
  }

  disk { # data disk
    aio          = "native"
    backup       = true
    cache        = "none"
    datastore_id = each.value.vm_datastore_id_data_disk
    discard      = "on"
    file_format  = each.value.vm_data_disk_format
    interface    = "scsi1"
    iothread     = true
    replicate    = false
    size         = each.value.vm_data_disk_size
  }

  dynamic "efi_disk" {
    for_each = each.value.vm_efi ? [1] : []
    content {
      datastore_id      = each.value.vm_datastore_id_efi_disk
      file_format       = "raw"
      pre_enrolled_keys = false
      type              = "4m"
    }
  }

  initialization {
    datastore_id = each.value.vm_datastore_id_initialization
    dns {
      domain  = each.value.vm_domain
      servers = each.value.vm_dns
    }
    ip_config {
      ipv4 {
        address = "${each.value.vm_ip}/24"
        gateway = each.value.vm_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  memory {
    dedicated = each.value.vm_memory_dedicated
    floating  = each.value.vm_memory_floating
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = false
    mac_address = each.value.vm_mac_address
    model       = "virtio"
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
      datastore_id = each.value.vm_datastore_id_tpm
      version      = "v2.0"
    }
  }

  vga {
    clipboard = "" # false if empty
    type      = "virtio"
  }
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = each.value.snippet_datastore_id
  node_name    = each.value.snippet_pve

  source_raw {
    data      = each.value.data
    file_name = "${each.key}_ci_meta-data.yml"
  }
}
