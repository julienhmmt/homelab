packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntujammy" {
  bios                     = "seabios"
  boot_command             = ["c", "linux /casper/vmlinuz -- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", "<enter><wait><wait>", "initrd /casper/initrd", "<enter><wait><wait>", "boot<enter>"]
  boot_wait                = "10s"
  cores                    = var.template_nb_core
  cpu_type                 = var.template_type_cpu
  http_directory           = "http"
  http_port_min            = 8100
  http_port_max            = 8100
  insecure_skip_tls_verify = true
  iso_url                  = var.iso_url
  iso_checksum             = var.iso_checksum
  iso_download_pve         = true
  iso_storage_pool         = var.iso_storage_pool
  machine                  = "q35"
  memory                   = var.template_nb_ram
  node                     = var.proxmox_node
  os                       = "l26"
  password                 = var.proxmox_api_token_secret
  proxmox_url              = var.proxmox_url
  qemu_agent               = true
  scsi_controller          = "virtio-scsi-pci"
  ssh_username             = var.template_ssh_username
  ssh_password             = var.template_sudo_password
  ssh_timeout              = "20m"
  sockets                  = var.template_nb_cpu
  template_description     = "Ubuntu Jammy (22.04) Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  unmount_iso              = true
  username                 = var.proxmox_api_token_id
  vm_name                  = var.template_name
  vm_id                    = var.template_vm_id

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

  network_adapters {
    bridge   = var.bridge_name
    firewall = true
    model    = "virtio"
  }
}
