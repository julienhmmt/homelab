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

resource "proxmox_virtual_environment_download_file" "nixos_latest" {
  checksum           = "694e26555771bfbad4c157ddb398ae8444a15122f0073141af3784ebd06f19fb"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "nixos_24.11.iso"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso"
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    proxmox_virtual_environment_download_file.nixos_latest,
    random_password.vm_root_password
  ]

  for_each = var.vm

  bios                = "seabios"
  boot_order          = ["ide0", "scsi0", "scsi1"]
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

  cdrom {
    enabled = true
    # file_id = proxmox_virtual_environment_download_file.nixos_latest.file_name
    file_id = "${proxmox_virtual_environment_download_file.nixos_latest.datastore_id}:iso/${proxmox_virtual_environment_download_file.nixos_latest.file_name}"
    interface = "ide0"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = each.value.disk_vm_datastore
    discard      = "on"
    # file_id      = local.disk_image_map[each.value.disk_vm_img]
    iothread     = true
    interface    = "scsi0" # scsi-0QEMU_QEMU_HARDDISK_drive-scsi0
    replicate    = false
    size         = each.value.disk_size
  }
  
  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = each.value.disk_vm_datastore
    discard      = "on"
    iothread     = true
    interface    = "scsi1" # scsi-0QEMU_QEMU_HARDDISK_drive-scsi1
    replicate    = false
    size         = each.value.disk_size
  }

  efi_disk {
    datastore_id      = each.value.disk_efi_datastore
    pre_enrolled_keys = false
    type              = "4m"
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

  tpm_state {
    datastore_id = "local-nvme-vm"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }

  provisioner "file" {
    source      = "./config/configuration-test-nix.nix"
    destination = "/etc/nixos/configuration.nix"
  }

  provisioner "remote-exec" {
    inline = [
      "nixos-rebuild switch",
      "systemctl enable sshd",
      "systemctl start sshd"
    ]
  }
}
