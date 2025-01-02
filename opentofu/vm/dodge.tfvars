cloudinit_initialization = false
cpu_cores                = 2
create_file              = true
description              = "Managed by OpenTofu. Talos control plane"
disk_efi_datastore       = ""
disk_efi_creation        = false
disk_size                = 32
disk_vm_datastore        = "local-nvme-vm"
disk_vm_img              = "talos" # or "talos_wkr_ram", "talos_wkr_viper"
dns_servers              = [""]
domain                   = ""
firewall_enabled         = false
hostname                 = "dodge"
ipv4                     = ""
net_mac_address          = "BC:24:11:CA:FE:00"
net_rate_limit           = 0
pool_id                  = "prod"
ram                      = 4096
ram_floating             = 4096 # égale à la RAM pour le balooning
start_on_boot            = true
started                  = true
startup_order            = "1"
tags                     = ["cp", "infra", "kubernetes", "talos"]
talos_vm                 = true
vm_id                    = 991200

meta_config_metadata = {
  #   "tesla" = <<-EOF
  #     instance-id: tesla-instance
  #     local-hostname: tesla
  #   EOF
}

user_cloud_config = {
  #   "tesla" = {
  #     user_data_path = "cloud-init/tesla.yaml"
  #   }
}