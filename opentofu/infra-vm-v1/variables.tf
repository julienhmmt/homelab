variable "vm" {
  type = map(object({
    cpu_cores          = number
    description        = string
    disk_efi_datastore = string
    disk_size          = number
    disk_vm_datastore  = string
    dns_servers        = list(string)
    domain             = string
    firewall_enabled   = bool
    hostname           = string
    ipv4               = string
    net_mac_address    = string
    net_rate_limit     = number
    os                 = string
    pool_id            = string
    ram                = number
    start_on_boot      = bool
    started            = bool
    startup_order      = string
    tags               = list(string)
    vm_id              = number
    additional_disks   = optional(map(object({
      datastore_id      = string
      path_in_datastore = string
      file_format       = string
      size              = number
    })), {})
  }))
}

variable "meta_config_metadata" {
  type = map(string)
  default = {
    "debian12" = <<-EOF
      instance-id: debian12-instance
      local-hostname: debian12
    EOF
  }
}

variable "user_cloud_config" {
  type = map(string)
}
