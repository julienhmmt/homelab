resource "proxmox_virtual_environment_vm" "talos_wkr_ram" {
  depends_on = [
    proxmox_virtual_environment_download_file.talos_img,
    proxmox_virtual_environment_vm.talos_cp_dodge
  ]

  bios            = "seabios"
  description     = "Managed by OpenTofu. Talos worker pour les services d'infra."
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name            = "ram"
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
  vm_id               = 192168122

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = 2
    numa    = true
    sockets = 1
    type    = "host"
  }

  disk {
    datastore_id = "zfs_nvme"
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

  efi_disk {
    datastore_id = "zfs_nvme"
    file_format = "raw"
    pre_enrolled_keys = false
    type = "4m"
  }

  memory {
    dedicated = 8192
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
    order      = "2"
    up_delay   = 15
    down_delay = 60
  }

  tpm_state {
    datastore_id = "zfs_nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
