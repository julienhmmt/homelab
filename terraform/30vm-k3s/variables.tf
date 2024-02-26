variable "clone_node_name" {
  type = string
}
variable "clone_vm_id" {
  type = number
}
variable "cloudinit_dns_domain" {
  type = string
}
variable "cloudinit_dns_servers" {
  type = list(string)
}
variable "cloudinit_ssh_keys" {
  type = list(string)
}
variable "cloudinit_user_account" {
  type = string
}
variable "datastore_id" {
  type = string
}
variable "net_rate_limit" {
  type = number
}
variable "disk_file_format" {
  type = string
}
variable "pve_api_token" {
  type = string
}
variable "pve_host_address" {
  type = string
}
variable "tmp_dir" {
  type = string
}
variable "vm_bridge_lan" {
  type = string
}
variable "vm_cpu_cores_number" {
  type = number
}
variable "vm_cpu_type" {
  type = string
}
variable "vm_description" {
  type = string
}
variable "vm_disk_size" {
  type = number
}
variable "vm_socket_number" {
  type = number
}
