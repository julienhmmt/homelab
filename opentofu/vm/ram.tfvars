cloudinit_initialization = false
cpu_cores                = 4
create_file              = false
description              = "Managed by OpenTofu. Talos worker INFRA"
disk_efi_datastore       = ""
disk_efi_creation        = false
disk_size                = 64
disk_vm_datastore        = "local-nvme-vm"
disk_vm_img              = "talos" # or "talos_wkr_ram", "talos_wkr_viper"
dns_servers              = [""]
domain                   = ""
firewall_enabled         = false
hostname                 = "ram"
ipv4                     = ""
net_mac_address          = "BC:24:11:CA:FE:01"
net_rate_limit           = 0
pool_id                  = "prod"
ram                      = 8192
ram_floating             = 8192 # égale à la RAM pour le balooning
start_on_boot            = true
started                  = true
startup_order            = "2"
tags                     = ["infra", "kubernetes", "talos", "worker"]
talos_vm                 = true
vm_id                    = 991201