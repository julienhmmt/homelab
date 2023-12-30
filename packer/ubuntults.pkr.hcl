packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntujammy" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_api_token_id
  password                 = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  vm_name              = var.template_name
  template_description = "Ubuntu Jammy (22.04) Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  vm_id                = var.template_vm_id
  os                   = "l26"
  cpu_type             = var.template_type_cpu
  sockets              = var.template_nb_cpu
  cores                = var.template_nb_core
  memory               = var.template_nb_ram
  machine              = "q35"
  bios                 = "seabios"
  scsi_controller      = "virtio-scsi-pci"
  qemu_agent           = true

  network_adapters {
    bridge   = var.bridge_name
    firewall = true
    model    = "virtio"
  }

  disks {
    disk_size    = var.template_disk_size
    format       = var.template_disk_format
    storage_pool = var.template_storage_pool
    type         = "scsi"
  }
  efi_config {
    efi_storage_pool  = var.template_storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  iso_download_pve = true
  iso_storage_pool = var.iso_storage_pool
  unmount_iso      = true

  http_directory = "http"
  http_port_min  = 8100
  http_port_max  = 8100
  boot_wait      = "10s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait><wait>",
    "initrd /casper/initrd",
    "<enter><wait><wait>",
    "boot",
    "<enter>"
  ]

  ssh_username = var.template_ssh_username
  ssh_password = var.template_sudo_password
  ssh_timeout  = "20m"
}
