cloudinit_initialization = false
cpu_cores                = 1
description              = "Managed by OpenTofu. Installed packages : `cockpit`, `nut`."
disk_efi_datastore       = "local-nvme-vm"
disk_efi_creation        = true
disk_size                = 16
disk_vm_datastore        = "local-nvme-vm"
disk_vm_img              = "ubuntu24"      # ubuntu22, ubuntu22_minimal, ubuntu24, ubuntu24_minimal, or "talos_wkr_ram", "talos_wkr_viper"
dns_servers              = ["192.168.1.2"] # ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
domain                   = "prive.dc.local.hommet.net"
firewall_enabled         = false
hostname                 = "tesla"
ipv4                     = "192.168.1.199/24"
net_mac_address          = "BC:24:11:CA:FE:99"
net_rate_limit           = 0
pool_id                  = "prod"
ram                      = 1024
ram_floating             = 1024 # égale à la RAM pour le balooning
start_on_boot            = true
started                  = true
startup_order            = "1"
tags                     = ["infra", "ubuntu"]
talos_vm                 = false
vm_id                    = 991199

meta_config_metadata = {
  "tesla" = <<-EOF
    instance-id: tesla-instance
    local-hostname: tesla
  EOF
}

user_cloud_config = {
  "tesla" = {
    user_data_path = "cloud-init/tesla.yaml"
  }
}