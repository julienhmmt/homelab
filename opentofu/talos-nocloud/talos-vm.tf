# Machines pour le stockage de données statiques pour Talos
resource "proxmox_virtual_environment_vm" "talos_vm_data" {
  description = "Managed by OpenTofu. Talos data disks."
  name        = "k8s-data"
  node_name   = "miniquarium"
  on_boot     = false
  protection  = true
  started     = false
  tags        = sort(["infra", "ne_pas_demarrer", "ne_pas_supprimer"])
  vm_id       = 9000

  disk { # control plane data disk 1
    backup       = true
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi10"
    size         = 48
  }
  disk { # worker 1 data disk 1
    backup       = true
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi11"
    size         = 64
  }
  disk { # worker 2 data disk 1
    backup       = true
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi12"
    size         = 64
  }
}

# Déclaration de machine virtuelle pour Talos
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

  dynamic "disk" { # data disk
    for_each = { for idx, disk in proxmox_virtual_environment_vm.talos_vm_data.disk : idx => disk if disk.interface == each.value.data_vm_interface_disk }
    iterator = data_disk
    content {
      datastore_id = data_disk.value.datastore_id
      discard      = "on"
      file_format  = data_disk.value.file_format
      size         = data_disk.value.size
      interface    = each.value.vm_data_disk_interface
    }
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
