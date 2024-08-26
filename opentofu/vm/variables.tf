variable "vm" {
  type = map(object({
    cpu_cores        = number
    description      = string
    disk_size        = number
    domain           = string
    firewall_enabled = bool
    hostname         = string
    id               = number
    ipv4_address     = string
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

variable "cloud_config_scripts" {
  type = map(string)
}