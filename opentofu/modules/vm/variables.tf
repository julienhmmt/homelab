variable "cloudinit_dns_domain" {
  description = "DNS domain for cloud-init"
  type        = string
}

variable "cloudinit_dns_servers" {
  description = "List of DNS servers for cloud-init"
  type        = list(string)
}

variable "cloudinit_ssh_keys" {
  description = "SSH keys for cloud-init"
  type        = list(string)
}

variable "cloudinit_user_account" {
  description = "Username for cloud-init"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "pve_api_token" {
  description = "Proxmox API token"
  type        = string
}

variable "pve_host_address" {
  description = "Proxmox host address"
  type        = string
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
}

variable "tmp_dir" {
  description = "Temporary directory for VM setup"
  type        = string
}

variable "vm_bridge_lan" {
  description = "Network bridge for the VM"
  type        = string
}

variable "vm_cpu_cores_number" {
  description = "Number of CPU cores"
  type        = number
}

variable "vm_cpu_type" {
  description = "Type of CPU"
  type        = string
}

variable "vm_datastore_id" {
  description = "Datastore ID for the VM"
  type        = string
}

variable "vm_description" {
  description = "Description of the VM"
  type        = string
}

variable "vm_disk_size" {
  description = "Size of the VM disk in GB"
  type        = number
}

variable "vm_gateway_ipv4" {
  description = "Gateway IPv4 address for the VM"
  type        = string
}

variable "vm_id" {
  description = "Unique ID for the VM"
  type        = number
}

variable "vm_img_name" {
  description = "Name of the VM image"
  type        = string
  default     = "debian-12-genericcloud-amd64.img"
}

variable "vm_ipv4_address" {
  description = "IPv4 address for the VM"
  type        = string
}

variable "vm_memory_max" {
  description = "Maximum memory for the VM"
  type        = number
}

variable "vm_memory_min" {
  description = "Minimum memory for the VM"
  type        = number
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vm_socket_number" {
  description = "Number of CPU sockets"
  type        = number
}

variable "vm_startup_order" {
  description = "Startup order for the VM"
  type        = string
}
