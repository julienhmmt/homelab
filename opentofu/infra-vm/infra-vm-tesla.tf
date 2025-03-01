# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_tesla" {
  length  = 24
  special = true
}

output "vm_root_password_tesla" {
  value     = random_password.vm_root_password_tesla.result
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_tesla" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      instance-id: tesla-instance
      local-hostname: tesla
    EOF
    file_name = "tesla_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config_tesla" {

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_file {
    path      = "./cloud-init/tesla-arch.yml"
    file_name = "tesla_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "onduleur" {
  comment = "UPS Eaton 3S"
  name    = "onduleur"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "miniquarium"
    },
  ]
}

resource "proxmox_virtual_environment_vm" "vm_tesla" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_tesla,
    proxmox_virtual_environment_file.user_cloud_config_tesla,
    random_password.vm_root_password_tesla
  ]

  boot_order      = ["scsi0"]
  bios            = "ovmf"
  description     = "Tesla VM. Services installés : `cockpit`, `nut`."
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name            = "tesla"
  node_name       = "miniquarium"
  on_boot         = true
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
  vm_id               = 131

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
    file_id      = "local:iso/Arch-Linux-x86_64-cloudimg.img"
    iothread     = true
    interface    = "scsi0"
    replicate    = false
    size         = 24
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
        address = "192.168.1.31/24"
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_tesla.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_tesla.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = false
    mac_address  = "BC:24:11:CA:FE:31"
    rate_limit   = 100
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
    order      = 5
    up_delay   = 5
    down_delay = 60
  }

  usb {
    mapping = "onduleur"
    usb3    = false
  }

  tpm_state {
    datastore_id = "local-nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
