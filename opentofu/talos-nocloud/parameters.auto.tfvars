kubernetes_version     = "1.32.0"
talos_cluster_name     = "localhommetnet_k8sv1"
talos_cluster_endpoint = "192.168.1.21"
talos_version          = "1.9.2"

meta_config_metadata = {
  "dodge" = <<-EOF
    instance-id: talos-dodge
    local-hostname: dodge
  EOF

  "ram" = <<-EOF
    instance-id: talos-ram
    local-hostname: ram
  EOF

  "viper" = <<-EOF
    instance-id: talos-viper
    local-hostname: viper
  EOF
}

# user_cloud_config = {
#   "dodge" = {
#     user_data_path = "files/user-data-dodge.yaml"
#   }
#   "ram" = {
#     user_data_path = "files/user-data-ram.yaml"
#   }
#   "viper" = {
#     user_data_path = "files/user-data-viper.yaml"
#   }
# }

nodes = {
  "dodge" = {
    node_usage   = "infra" # 'infra' or 'general' 
    role         = "controlplane"
    vm_cpu_cores = 2
    vm_cpu_type  = "x86-64-v2-AES"
    # vm_datastore_id     = optional(string, "zfs_nvme")
    vm_description = "Managed by OpenTofu. Talos controlplane"
    vm_disk_size   = 64
    # vm_disk_format      = "raw"
    vm_efi              = true
    vm_eth_rate_limit   = 0
    vm_id               = 121
    vm_install_disk     = "/dev/sda"
    vm_ip               = "192.168.1.21/24"
    vm_name             = "dodge"
    vm_mac_address      = "BC:24:11:CA:FE:01"
    vm_memory_dedicated = 4096
    vm_pool_id          = ""
    vm_startup_order    = 2
    vm_tags             = ["k8s", "opentofu"]
    vm_tpm              = true
  }

  "ram" = {
    node_usage   = "infra" # 'infra' or 'general' 
    role         = "worker"
    vm_cpu_cores = 2
    vm_cpu_type  = "x86-64-v2-AES"
    # vm_datastore_id     = optional(string, "zfs_nvme")
    vm_description = "Managed by OpenTofu. Talos worker for infrastructure service"
    vm_disk_size   = 128
    # vm_disk_format      = "raw"
    vm_efi              = true
    vm_eth_rate_limit   = 0
    vm_id               = 122
    vm_install_disk     = "/dev/sda"
    vm_ip               = "192.168.1.22/24"
    vm_name             = "ram"
    vm_mac_address      = "BC:24:11:CA:FE:02"
    vm_memory_dedicated = 8192
    vm_pool_id          = ""
    vm_startup_order    = 3
    vm_tags             = ["k8s", "opentofu"]
    vm_tpm              = true
  }

  "viper" = {
    node_usage   = "viper" # 'infra' or 'general' 
    role         = "worker"
    vm_cpu_cores = 4
    vm_cpu_type  = "host"
    # vm_datastore_id     = optional(string, "zfs_nvme")
    vm_description = "Managed by OpenTofu. Talos worker for everything"
    vm_disk_size   = 256
    # vm_disk_format      = "raw"
    vm_efi              = true
    vm_eth_rate_limit   = 0
    vm_id               = 123
    vm_install_disk     = "/dev/sda"
    vm_ip               = "192.168.1.23/24"
    vm_name             = "viper"
    vm_mac_address      = "BC:24:11:CA:FE:03"
    vm_memory_dedicated = 16384
    vm_pool_id          = ""
    vm_startup_order    = 4
    vm_tags             = ["k8s", "opentofu"]
    vm_tpm              = true
  }
}
