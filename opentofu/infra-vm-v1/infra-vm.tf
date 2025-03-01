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

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      instance-id: ${each.key}-instance
      local-hostname: ${each.key}
    EOF
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  for_each = var.user_cloud_config

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_file {
    path      = each.value
    file_name = "${each.key}_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config,
    proxmox_virtual_environment_file.user_cloud_config,
    random_password.vm_root_password
  ]

  for_each = var.vm

  boot_order          = ["scsi0"]
  bios                = "ovmf"
  description         = each.value.description
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = each.value.hostname
  node_name           = "miniquarium"
  on_boot             = each.value.start_on_boot
  pool_id             = each.value.pool_id
  reboot_after_update = false
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
    flags   = []
    numa    = true
    sockets = 1
    type    = each.value.cpu_type
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = each.value.disk_vm_datastore
    discard      = "on"
    file_id = (
      each.value.os == "debian12" ? "local:iso/debian-12-genericcloud-amd64.img" :
      each.value.os == "ubuntu22" ? "local:iso/ubuntu-22-amd64.img" :
      each.value.os == "ubuntu24" ? "local:iso/ubuntu-24-amd64.img" :
      each.value.os == "almalinux" ? "local:iso/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.img" :
      each.value.os == "archlinux" ? "local:iso/Arch-Linux-x86_64-cloudimg.img" :
      null
    )
    iothread  = true
    interface = "scsi0"
    replicate = false
    size      = each.value.disk_size
  }

  # dynamic "disk" {
  #   for_each = each.value.hostname == "charger" ? var.vm_data : {}
  #   content {
  #     datastore_id      = disk.value.datastore_id
  #     path_in_datastore = disk.value.path_in_datastore
  #     file_format       = disk.value.file_format
  #     size              = disk.value.size
  #     interface         = "scsi${disk.key + 1}"
  #   }
  # }

  efi_disk {
    datastore_id      = each.value.disk_efi_datastore
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = each.value.disk_vm_datastore

    dns {
      domain  = each.value.domain
      servers = each.value.dns_servers
    }

    ip_config {
      ipv4 {
        address = "${each.value.ipv4}/24"
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config[each.key].id
    user_data_file_id = contains(keys(proxmox_virtual_environment_file.user_cloud_config), each.key) ? proxmox_virtual_environment_file.user_cloud_config[each.key].id : null
  }

  memory {
    dedicated = each.value.ram
    floating  = each.value.ram
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = each.value.firewall_enabled
    mac_address  = each.value.net_mac_address
    rate_limit   = each.value.net_rate_limit
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
    up_delay   = 5
    down_delay = 60
  }

  dynamic "usb" {
    for_each = each.value.hostname == "tesla" ? [1] : []
    content {
      mapping = "onduleur"
      usb3    = false
    }
  }

  tpm_state {
    datastore_id = "local-nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
