variable "vm" {
  type = map(object({
    cpu_cores        = number
    description      = string
    disk_datastore   = string
    disk_size        = number
    dns_servers      = list(string)
    domain           = string
    firewall_enabled = bool
    hostname         = string
    ipv4             = string
    net_mac_address  = string
    net_rate_limit   = number
    pool_id          = string
    ram              = number
    start_on_boot    = bool
    started          = bool
    startup_order    = string
    tags             = list(string)
    vm_id            = number
  }))
}

variable "meta_config_metadata" {
  type = map(string)
}

# variable "network_config_metadata" {
#   type = map(string)
# }

variable "cloud_config_scripts" {
  type = map(string)
}
