variable "vm" {
  type = map(object({
    cpu_cores          = number
    cpu_type           = string
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
    additional_disks = optional(map(object({
      datastore_id      = string
      path_in_datastore = string
      file_format       = string
      size              = number
    })), {})
  }))
}

variable "vm_data" {
  type = map(object({
    disk_size         = number
    disk_vm_datastore = string
    vm_id             = number
  }))
}

variable "meta_config_metadata" {
  type = map(string)
  default = {
    "cloudimg" = <<-EOF
      instance-id: cloud-instance
      local-hostname: cloudimg
    EOF
  }
}

variable "user_cloud_config" {
  type = map(string)
}
