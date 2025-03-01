# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_charger" {
  length           = 24
  special          = true
}

output "vm_root_password_charger" {
  value     = random_password.vm_root_password_charger
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_charger" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      instance-id: charger-instance
      local-hostname: charger
    EOF
    file_name = "charger_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config_charger" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_file {
    path      = "./cloud-init/charger-arch.yml"
    file_name = "charger_ci_user-data.yml"
  }
}

resource "null_resource" "trigger_vm_update_charger" {
  triggers = {
    user_cloud_config_checksum = filemd5("./cloud-init/charger-arch.yml")
  }

  provisioner "local-exec" {
    command = "echo 'User cloud config updated'"
  }
}

resource "proxmox_virtual_environment_vm" "data_vm_charger" {
  node_name  = "miniquarium"
  on_boot    = false
  protection = true
  started    = false
  vm_id      = 9132

  disk {
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 128
  }
}

resource "proxmox_virtual_environment_vm" "vm_charger" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_charger,
    proxmox_virtual_environment_file.user_cloud_config_charger,
    proxmox_virtual_environment_vm.data_vm_charger,
    random_password.vm_root_password_charger,
    null_resource.trigger_vm_update_charger
  ]

  boot_order          = ["scsi0"]
  bios                = "ovmf"
  description         = "Tesla VM. Services installés : `cockpit`, `nfs-server`."
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = "charger"
  node_name           = "miniquarium"
  on_boot             = true
  # pool_id             = each.value.pool_id
  reboot_after_update = false
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  stop_on_destroy     = true
  tablet_device       = false
  tags                = ["arch", "infra", "vm"]
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = 132

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = 1
    flags   = []
    numa    = true
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = "local-nvme"
    discard      = "on"
    file_id = "local:iso/Arch-Linux-x86_64-cloudimg.img"
    iothread  = true
    interface = "scsi0"
    replicate = false
    size      = 24
  }

  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm_charger.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      interface         = "scsi${data_disk.key + 1}"
    }
  }

  efi_disk {
    datastore_id      = "local-nvme"
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = "local-nvme"

    dns {
      domain  = "dc.local.hommet.net"
      servers = ["192.168.1.254", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.32/24"
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_charger.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_charger.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = false
    mac_address  = "BC:24:11:CA:FE:32"
    rate_limit   = 0
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
    order      = 1
    up_delay   = 5
    down_delay = 60
  }

  tpm_state {
    datastore_id = "local-nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
