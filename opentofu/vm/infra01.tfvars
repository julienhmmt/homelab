cpu_cores          = 1
description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. Used only for infra services."
disk_efi_datastore = "local-nvme-vm"
disk_size          = 32
disk_vm_datastore  = "local-nvme-vm"
disk_vm_img        = "ubuntu24" # values: archlinux, debian12, ubuntu22, ubuntu22_minimal, ubuntu24, ubuntu24_minimal
dns_servers        = ["192.168.1.2", "1.1.1.1"] # ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
domain             = "prive.dc.local.hommet.net"
firewall_enabled   = false
hostname           = "infra01"
ipv4               = "192.168.1.101/24"
net_mac_address    = "BC:24:11:CA:FE:01"
net_rate_limit     = 0
pool_id            = "prod"
ram                = 512
start_on_boot      = true
started            = true
startup_order      = "2"
tags               = ["infra", "ubuntu24"]
vm_id              = 9991201

meta_config_metadata = {
  "infra01" = <<-EOF
    instance-id: infra01-instance
    local-hostname: infra01
  EOF
}

user_data_path = "cloud-init/infra01.yaml"
