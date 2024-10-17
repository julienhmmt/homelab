variable "ct" {
  description = "Managed by OpenTofu."
  type = map(object({
    cpu_cores           = number
    description         = string
    disk_size           = number
    domain              = string
    hostname            = string
    id                  = number
    ipv4                = string
    net_mac_address     = string
    net_rate_limit      = number
    pool_id             = string
    ram                 = number
    start_on_boot       = bool
    startup_order       = number
    startup_up_delay    = number
    swap                = number
    tags                = list(string)
    unprivileged        = bool
  }))
}
