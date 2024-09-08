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

# location of containers templates
# resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg_latest" {
#   content_type = "iso"
#   datastore_id = "local"
#   file_name    = "Arch-Linux-x86_64-cloudimg.qcow2.img"
#   node_name    = "pve1"
#   overwrite    = true
#   url          = "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
# }

resource "proxmox_virtual_environment_vm" "archlinux_vm" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config,
    # proxmox_virtual_environment_file.network_cloud_config,
    proxmox_virtual_environment_file.cloud_config,
    random_password.vm_root_password
  ]

  for_each = var.vm

  bios                = "ovmf"
  description         = each.value.description
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = each.value.hostname
  node_name           = "pve1"
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

  clone {
    datastore_id = "local-zfs"
    full         = true
    node_name    = "pve1"
    retries      = 2
    vm_id        = 100
  }

  cpu {
    architecture = "x86_64"
    cores        = each.value.cpu_cores
    numa         = true
    sockets      = 1
    type         = "host"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = "local-zfs"
    discard      = "on"
    # file_id      = proxmox_virtual_environment_download_file.archlinux_cloudimg_latest.id
    iothread  = true
    interface = "scsi0"
    replicate = false
    size      = each.value.disk_size
  }

  efi_disk {
    datastore_id      = "local-zfs"
    pre_enrolled_keys = true
    type              = "4m"
  }

  initialization {
    datastore_id = "local-zfs"

    dns {
      domain  = each.value.domain
      servers = each.value.dns_servers
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config[each.key].id
    # network_data_file_id = proxmox_virtual_environment_file.network_cloud_config[each.key].id
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[each.key].id
  }

  memory {
    dedicated = each.value.ram
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
    up_delay   = 60
    down_delay = 60
  }
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  for_each = var.meta_config_metadata

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve1"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_meta-data.yml"
  }
}

# resource "proxmox_virtual_environment_file" "network_cloud_config" {
#   for_each = var.network_config_metadata

#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve1"

#   source_raw {
#     data      = each.value
#     file_name = "${each.key}_network_meta-data.yml"
#   }
# }

resource "proxmox_virtual_environment_file" "cloud_config" {
  for_each = var.cloud_config_scripts

  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve1"

  source_raw {
    data      = each.value
    file_name = "${each.key}_ci_user-data.yml"
  }
}
