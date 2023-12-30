variable "bridge_name" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}

variable "iso_url" {
  type = string
}

variable "proxmox_api_url" {
  type    = string
  default = ""
}

variable "proxmox_api_token_id" {
  type    = string
  default = ""
}

variable "proxmox_api_token_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "storage_pool" {
  type    = string
  default = "datastore"
}

variable "template_disk_format" {
  type    = string
  default = "qcow2"
}

variable "template_disk_size" {
  type    = string
  default = "16G"
}

variable "template_name" {
  type    = string
  default = "ubjammy-pcker"
}

variable "template_nb_core" {
  type    = string
  default = "1"
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

variable "template_sudo_password" {
  type      = string
  default   = "password"
  sensitive = true
}

variable "template_type_cpu" {
  type    = string
  default = "kvm64"
}

variable "template_vm_id" {
  type    = number
  default = 99999
}
