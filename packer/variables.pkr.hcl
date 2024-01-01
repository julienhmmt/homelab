variable "bios_type" {
  type = string
}

variable "boot_command" {
  type = string
}

variable "boot_wait" {
  type = string
}

variable "bridge_name" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_download_pve" {
  type = boolean
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
  type    = boolean
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
  type    = boolean
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

variable "template_name" {
  type    = string
  default = "ubjammy-pcker"
}

variable "template_nb_core" {
  type    = integer
  default = 1
}

variable "template_nb_cpu" {
  type    = integer
  default = 1
}

variable "template_nb_ram" {
  type    = integer
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
  type    = integer
  default = 99999
}
