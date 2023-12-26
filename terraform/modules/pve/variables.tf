variable "ct_bridge" {
  type = string
}
variable "ct_datastore_storage_location" {
  type = string
}
variable "ct_datastore_template_location" {
  type = string
}
variable "ct_disk_size" {
  type    = string
  default = "20"
}
variable "ct_nic_rate_limit" {
  type = number
}
variable "ct_memory" {
  type = number
}
variable "ct_source_file_path" {
  type = string
}
variable "dns_domain" {
  type = string
}
variable "dns_server" {
  type = string
}
variable "gateway" {
  type = string
}
variable "os_type" {
  type = string
}
variable "pve_api_token" {
  type = string
}
variable "pve_api_user" {
  type = string
}
variable "pve_host_address" {
  type = string
}
variable "tmp_dir" {
  type = string
}