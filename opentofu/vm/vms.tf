# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "vm_root_password" {
  value     = random_password.vm_root_password.result
  sensitive = true
}

data "terraform_remote_state" "cloudimg" {
  backend = "local"
  config = {
    path = "../cloudimg/terraform.tfstate"
  }
}

locals {
  disk_image_map = {
    archlinux        = data.terraform_remote_state.cloudimg.outputs.archlinux_cloudimg_latest_file_id
    debian12         = data.terraform_remote_state.cloudimg.outputs.debian12_cloudimg_latest_file_id
    ubuntu22         = data.terraform_remote_state.cloudimg.outputs.ubuntu22_cloudimg_latest_file_id
    ubuntu22_minimal = data.terraform_remote_state.cloudimg.outputs.ubuntu22_minimal_cloudimg_latest_file_id
    ubuntu24         = data.terraform_remote_state.cloudimg.outputs.ubuntu24_cloudimg_latest_file_id
    ubuntu24_minimal = data.terraform_remote_state.cloudimg.outputs.ubuntu24_minimal_cloudimg_latest_file_id
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  depends_on = [
    #   proxmox_virtual_environment_download_file.archlinux_cloudimg_latest,
    #   proxmox_virtual_environment_download_file.debian_cloudimg_202411,
    #   proxmox_virtual_environment_download_file.ubuntu22_cloudimg_latest,
    #   proxmox_virtual_environment_download_file.ubuntu22_cloudimg_minimal_latest,
    #   proxmox_virtual_environment_download_file.ubuntu24_cloudimg_latest,
    #   proxmox_virtual_environment_download_file.ubuntu24_cloudimg_minimal_latest,
    #   proxmox_virtual_environment_file.meta_cloud_config,
    #   proxmox_virtual_environment_file.user_cloud_config
    random_password.vm_root_password,
    # data.terraform_remote_state.iso
    data.terraform_remote_state.cloudimg
  ]

  bios = "seabios"
  description     = var.description
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name      = var.hostname
  node_name = "miniquarium"
  on_boot   = var.start_on_boot
  pool_id = var.pool_id
  scsi_hardware = "virtio-scsi-single"
  started         = var.started
  stop_on_destroy = true
  tablet_device   = false
  tags                = var.tags
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id = var.vm_id

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = var.cpu_cores
    numa    = true
    sockets = 1
    type    = "host"
  }

  disk {
    aio   = "native"
    cache = "none"
    datastore_id = var.disk_vm_datastore # 'local-nvme-vm'
    discard      = "on"
    file_id   = local.disk_image_map[var.disk_vm_img]
    iothread  = true
    interface = "scsi0"
    replicate = false
    size = var.disk_size
  }

  efi_disk {
    datastore_id = var.disk_efi_datastore
    type         = "4m"
  }

  initialization {
    datastore_id = var.disk_vm_datastore

    dns {
      domain = var.domain
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = var.ipv4
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config.id
  }

  memory {
    dedicated = var.ram
  }

  network_device {
    bridge = "vmbr0"
    firewall = var.firewall_enabled
    mac_address = var.net_mac_address
    rate_limit = var.net_rate_limit
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
    order      = var.startup_order
    up_delay   = 15
    down_delay = 60
  }

  # Only attach the USB device if the hostname is "infra01"
  dynamic "usb" {
    for_each = var.hostname == "infra01" ? [1] : []  # Only attach USB if hostname is "infra01"
    content {
      mapping = "ups"  # Reference the USB mapping created earlier
      usb3    = false   # Optional setting for USB3 support
    }
  }
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "ups" {
  count   = var.hostname == "infra01" ? 1 : 0  # Only create this resource when hostname is "infra01"
  comment = "UPS Eaton 3S"
  name    = "ups"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "miniquarium"
    },
  ]
}

resource "proxmox_virtual_environment_file" "meta_cloud_config" {
  content_type = "snippets"
  datastore_id = "local-nvme-vm"
  node_name    = "miniquarium"

  source_raw {
    data = var.meta_config_metadata["infra01"]
    file_name = "${var.hostname}_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config" {
  content_type = "snippets"
  datastore_id = "local-nvme-vm"
  node_name    = "miniquarium"

  source_file {
    path      = var.user_data_path
    file_name = "${var.hostname}_ci_user-data.yml"
  }
}
