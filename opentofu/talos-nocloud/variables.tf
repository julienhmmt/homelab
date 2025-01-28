variable "talos_cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "talos_cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "kubernetes_version" {
  type = string
}

variable "talos_version" {
  type = string
}

# talos-vm-{cp-worker}.tf
variable "nodes" {
  description = "Values of VM resources"
  type = map(object({
    node_usage          = string
    role                = string
    vm_cpu_cores        = number
    vm_cpu_type         = optional(string, "x86-64-v2-AES")
    vm_datastore_id     = optional(string, "zfs_nvme")
    vm_description      = string
    vm_disk_size        = number
    vm_disk_format      = optional(string, "raw")
    vm_efi              = optional(bool, true)
    vm_eth_rate_limit   = optional(number, 0)
    vm_id               = number
    vm_install_disk     = string
    vm_ip               = string
    vm_name             = string
    vm_mac_address      = string
    vm_memory_dedicated = number
    vm_pool_id          = optional(string)
    vm_startup_order    = optional(number, 1)
    vm_tags             = optional(list(string))
    vm_tpm              = optional(bool, true)
  }))
}

variable "meta_config_metadata" {
  type = map(string)
}
