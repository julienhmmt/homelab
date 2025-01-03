resource "proxmox_virtual_environment_vm" "talos_wkr_viper" {
  depends_on = [
    proxmox_virtual_environment_download_file.talos_img
  ]

  bios            = "seabios"
  description     = "Managed by OpenTofu. Talos worker pour tous les services annexes."
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name            = "viper"
  node_name       = "miniquarium"
  on_boot         = true
  # pool_id             = data.proxmox_virtual_environment_pools.available_pools
  scsi_hardware       = "virtio-scsi-single"
  started             = "true"
  stop_on_destroy     = true
  tablet_device       = false
  tags                = ["infra", "kubernetes", "talos", "worker"]
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = 9991202

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = 4
    numa    = true
    sockets = 1
    type    = "host"
  }

  # disk {
  #   datastore_id = "local-nvme-vm"
  #   file_id      = "local-nvme-vm:iso/talos-1.9.1.iso"
  #   interface    = "scsi0"
  # }

  disk {
    datastore_id = "local-nvme-vm"
    interface    = "scsi0"
    size         = 128
    # file_format  = "raw"
    file_id   = "${proxmox_virtual_environment_download_file.talos_img.datastore_id}:iso/${proxmox_virtual_environment_download_file.talos_img.file_name}"
    aio       = "native"
    cache     = "none"
    discard   = "on"
    iothread  = true
    replicate = false
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
    dedicated = 16384
    floating  = 16384
  }

  network_device {
    bridge      = "vmbr0"
    firewall    = false
    mac_address = "BC:24:11:CA:FE:02"
    rate_limit  = 0
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = "3"
    up_delay   = 15
    down_delay = 60
  }

  tpm_state {
    datastore_id = "local-nvme-vm"
    version      = "v2.0"
  }
}
