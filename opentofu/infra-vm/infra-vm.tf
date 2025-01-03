resource "proxmox_virtual_environment_vm" "infra_vm" {
  depends_on = []

  bios            = "seabios"
  description     = "Managed by OpenTofu. VM d'infra pour l'onduleur."
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name            = "tesla"
  node_name       = "miniquarium"
  on_boot         = true
  # pool_id             = data.proxmox_virtual_environment_pools.available_pools
  scsi_hardware       = "virtio-scsi-single"
  started             = "true"
  stop_on_destroy     = true
  tablet_device       = false
  tags                = ["infra", "ubuntu24"]
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = 9991199

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = 1
    numa    = true
    sockets = 1
    type    = "host"
  }

  disk {
    datastore_id = "local-nvme-vm"
    interface    = "scsi1"
    size         = 64
    file_format  = "raw"
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

  # dynamic "efi_disk" {
  #   for_each = var.disk_efi_creation ? [1] : []

  #   content {
  #     datastore_id = var.disk_efi_creation ? var.disk_efi_datastore : null
  #     type         = "4m"
  #   }
  # }


  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = false
    mac_address = "BC:24:11:CA:FE:10"
    rate_limit  = 0
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = "1"
    up_delay   = 15
    down_delay = 60
  }

  tpm_state {
    datastore_id = "local-nvme-vm"
    version      = "v2.0"
  }
}
