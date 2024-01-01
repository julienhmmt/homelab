packer {
  required_plugins {
    name = {
      version = "1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "bios_type" {
  type = string
}

variable "boot_command" {
  type = string
}

variable "boot_wait" {
  type = string
}

variable "bridge_firewall" {
  type    = bool
  default = false
}

variable "bridge_name" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_download_pve" {
  type = bool
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}

variable "iso_url" {
  type = string
}

variable "machine_default_type" {
  type    = string
  default = "pc"
}

variable "network_model" {
  type    = string
  default = "virtio"
}

variable "os_type" {
  type    = string
  default = "l26"
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "qemu_agent_activation" {
  type    = bool
  default = true
}

variable "scsi_controller_type" {
  type = string
}

variable "ssh_timeout" {
  type = string
}

variable "tags" {
  type = string
}

variable "template_cpu_type" {
  type    = string
  default = "kvm64"
}

variable "template_description" {
  type    = string
  default = "Ubuntu Jammy (22.04) Packer Template"
}

variable "template_disk_discard" {
  type    = bool
  default = true
}

variable "template_disk_format" {
  type    = string
  default = "qcow2"
}

variable "template_disk_size" {
  type    = string
  default = "16G"
}

variable "template_disk_type" {
  type    = string
  default = "scsi"
}

variable "template_nb_core" {
  type    = number
  default = 1
}

variable "template_nb_cpu" {
  type    = number
  default = 1
}

variable "template_nb_ram" {
  type    = number
  default = 1024
}

variable "template_ssh_username" {
  type    = string
  default = "user"
}

variable "template_storage_pool" {
  type    = string
  default = "local"
}

variable "template_sudo_password" {
  type      = string
  default   = "password"
  sensitive = true
}

variable "template_vm_id" {
  type    = number
  default = 99999
}

locals {
  packer_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "ubuntujammy" {
  bios                     = "${var.bios_type}"
  boot_command             = ["${var.boot_command}"]
  boot_wait                = "${var.boot_wait}"
  cores                    = "${var.template_nb_core}"
  cpu_type                 = "${var.template_cpu_type}"
  http_directory           = "autoinstall"
  insecure_skip_tls_verify = true
  iso_url                  = "${var.iso_url}"
  iso_checksum             = "${var.iso_checksum}"
  iso_download_pve         = true
  iso_storage_pool         = "${var.iso_storage_pool}"
  machine                  = "${var.machine_default_type}"
  memory                   = "${var.template_nb_ram}"
  node                     = "${var.proxmox_node}"
  os                       = "${var.os_type}"
  proxmox_url              = "${var.proxmox_api_url}"
  qemu_agent               = "${var.qemu_agent_activation}"
  scsi_controller          = "${var.scsi_controller_type}"
  ssh_username             = "${var.template_ssh_username}"
  ssh_password             = "${var.template_sudo_password}"
  ssh_timeout              = "${var.ssh_timeout}"
  sockets                  = "${var.template_nb_cpu}"
  tags                     = "${var.tags}"
  template_description     = "${var.template_description}.${local.packer_timestamp}"
  token                    = "${var.proxmox_api_token_secret}"
  unmount_iso              = true
  username                 = "${var.proxmox_api_token_id}"
  vm_id                    = "${var.template_vm_id}"
  vm_name                  = "pckr-ubuntu"

  disks {
    discard      = "${var.template_disk_discard}"
    disk_size    = "${var.template_disk_size}"
    format       = "${var.template_disk_format}"
    storage_pool = "${var.template_storage_pool}"
    type         = "${var.template_disk_type}"
  }

  network_adapters {
    bridge   = "${var.bridge_name}"
    firewall = "${var.bridge_firewall}"
    model    = "${var.network_model}"
  }
}

build {
  sources = ["source.proxmox-iso.ubuntujammy"]
  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean", "sudo passwd -d ubuntu"]
  }
}
