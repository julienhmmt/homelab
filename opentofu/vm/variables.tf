# variable "vm" {
#   type = map(object({
#     cpu_cores          = number
#     description        = string
#     disk_efi_datastore = string
#     disk_size          = number
#     disk_vm_datastore  = string
#     disk_vm_img        = string
#     dns_servers        = list(string)
#     domain             = string
#     firewall_enabled   = bool
#     hostname           = string
#     ipv4               = string
#     net_mac_address    = string
#     net_rate_limit     = number
#     pool_id            = string
#     ram                = number
#     start_on_boot      = bool
#     started            = bool
#     startup_order      = string
#     tags               = list(string)
#     vm_id              = number
#   }))
# }

variable "cpu_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
}

variable "description" {
  description = "Description of the VM"
  type        = string
}

variable "disk_efi_datastore" {
  description = "Datastore for EFI disk"
  type        = string
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = number
}

variable "disk_vm_datastore" {
  description = "The datastore for the VM disk"
  type        = string
}

variable "disk_vm_img" {
  description = "The disk image to use for the VM"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers to use for the VM"
  type        = list(string)
}

variable "domain" {
  description = "Domain for the VM"
  type        = string
}

variable "firewall_enabled" {
  description = "Enable or disable firewall for the VM"
  type        = bool
}

variable "hostname" {
  description = "Hostname for the VM"
  type        = string
}

variable "ipv4" {
  description = "IPv4 address for the VM"
  type        = string
}

variable "net_mac_address" {
  description = "MAC address for the network interface"
  type        = string
}

variable "net_rate_limit" {
  description = "Network rate limit for the VM in Mbps"
  type        = number
}

variable "pool_id" {
  description = "Pool ID to assign the VM to"
  type        = string
}

variable "ram" {
  description = "Amount of RAM in MB"
  type        = number
}

variable "start_on_boot" {
  description = "Should the VM start on boot"
  type        = bool
}

variable "started" {
  description = "Is the VM started"
  type        = bool
}

variable "startup_order" {
  description = "Startup order for the VM"
  type        = string
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
}

variable "vm_id" {
  description = "Unique ID for the VM"
  type        = number
}

variable "meta_config_metadata" {
  type = map(string)
}

# variable "user_cloud_config" {
#   type = map(object({
#     user_data_path = string
#   }))
# }
variable "user_data_path" {
  type = string
}
