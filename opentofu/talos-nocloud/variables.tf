variable "kubernetes_version" {
  type = string
}

variable "talos_cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}
variable "talos_cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}
variable "talos_pve_server" {
  description = "The Proxmox server where the Talos VMs are hosted"
  type        = string
}
variable "talos_version" {
  type = string
}

variable "nodes" {
  description = "Values of VM resources"
  type = map(object({
    data_vm_interface_disk         = string
    pve                            = string
    role                           = string
    usage                          = string
    vm_boot_disk_format            = optional(string, "raw")
    vm_boot_disk_size              = number
    vm_cpu_cores                   = number
    vm_cpu_flags                   = optional(list(string))
    vm_cpu_type                    = optional(string, "x86-64-v2-AES")
    vm_data_disk_interface         = string
    vm_datastore_id                = string
    vm_datastore_id_boot_disk      = string
    vm_datastore_id_data_disk      = string
    vm_datastore_id_efi_disk       = string
    vm_datastore_id_initialization = string
    vm_datastore_id_tpm            = string
    vm_description                 = string
    vm_dns                         = list(string)
    vm_domain                      = string
    vm_efi                         = optional(bool, true)
    vm_eth_rate_limit              = optional(number, 0)
    vm_gateway                     = string
    vm_id                          = number
    vm_install_disk                = string
    vm_ip                          = string
    vm_kvm_args                    = optional(string)
    vm_mac_address                 = string
    vm_memory_dedicated            = number
    vm_memory_floating             = number
    vm_name                        = string
    vm_on_boot                     = optional(bool, true)
    vm_pool_id                     = optional(string)
    vm_startup_order               = optional(number, 1)
    vm_started                     = optional(bool, true)
    vm_tags                        = optional(list(string))
    vm_timeservers                 = optional(list(string), ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"])
    vm_tpm                         = optional(bool, true)
  }))
}

variable "meta_config_metadata" {
  description = "Metadata for cloud-init configuration"
  type = map(object({
    snippet_datastore_id = string
    snippet_pve          = string
    data                 = string
  }))
}
