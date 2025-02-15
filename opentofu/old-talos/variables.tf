variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  # default = {
  #   controlplanes = {
  #     "10.5.0.2" = {
  #       install_disk = "/dev/sda"
  #     },
  #     "10.5.0.3" = {
  #       install_disk = "/dev/sda"
  #     },
  #     "10.5.0.4" = {
  #       install_disk = "/dev/sda"
  #     }
  #   }
  #   workers = {
  #     "10.5.0.5" = {
  #       install_disk = "/dev/nvme0n1"
  #       hostname     = "worker-1"
  #     },
  #     "10.5.0.6" = {
  #       install_disk = "/dev/nvme0n1"
  #       hostname     = "worker-2"
  #     }
  #   }
  # }
}

# variable "cloudinit_initialization" {
#   type    = bool
#   default = false
# }

# variable "cpu_cores" {
#   description = "Number of CPU cores for the VM"
#   type        = number
# }

# variable "create_file" {
#   description = "Whether to create or skip the upload of the Talos ISO file"
#   type        = bool
#   default     = true
# }

# variable "description" {
#   description = "Description of the VM"
#   type        = string
# }

# variable "disk_efi_creation" {
#   type    = bool
#   default = false
# }

# variable "disk_efi_datastore" {
#   description = "Datastore for EFI disk"
#   type        = string
# }

# variable "disk_size" {
#   description = "Size of the disk in GB"
#   type        = number
# }

# variable "disk_vm_datastore" {
#   description = "The datastore for the VM disk"
#   type        = string
# }

# variable "disk_vm_img" {
#   description = "The disk image to use for the VM"
#   type        = string
# }

# variable "dns_servers" {
#   description = "List of DNS servers to use for the VM"
#   type        = list(string)
# }

# variable "domain" {
#   description = "Domain for the VM"
#   type        = string
# }

# variable "firewall_enabled" {
#   description = "Enable or disable firewall for the VM"
#   type        = bool
# }

# variable "hostname" {
#   description = "Hostname for the VM"
#   type        = string
# }

# variable "ipv4" {
#   description = "IPv4 address for the VM"
#   type        = string
# }

# variable "net_mac_address" {
#   description = "MAC address for the network interface"
#   type        = string
# }

# variable "net_rate_limit" {
#   description = "Network rate limit for the VM in Mbps"
#   type        = number
# }

# variable "pool_id" {
#   description = "Pool ID to assign the VM to"
#   type        = string
# }

# variable "ram" {
#   description = "Amount of RAM in MB"
#   type        = number
# }

# variable "ram_floating" {
#   description = "Amount of RAM 'floating' in MB"
#   type        = number
# }

# variable "start_on_boot" {
#   description = "Should the VM start on boot"
#   type        = bool
# }

# variable "started" {
#   description = "Is the VM started"
#   type        = bool
# }

# variable "startup_order" {
#   description = "Startup order for the VM"
#   type        = string
# }

# variable "tags" {
#   description = "Tags for the VM"
#   type        = list(string)
# }

# variable "talos_vm" {
#   description = "Is it Talos VM?"
#   type        = bool
#   default     = false
# }

# variable "vm_id" {
#   description = "Unique ID for the VM"
#   type        = number
# }

# variable "meta_config_metadata" {
#   type = map(string)
# }

# variable "user_cloud_config" {
#   type = map(object({
#     user_data_path = string
#   }))
# }
