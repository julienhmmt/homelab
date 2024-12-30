# vm = {
#   "infra01" = {
#     cpu_cores          = 1
#     description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. Used only for infra services."
#     disk_efi_datastore = "zfsvm"
#     disk_size          = 32
#     disk_vm_datastore  = "zfsvm"
#     disk_vm_img        = "" # values: archlinux_iso_122024_file_id, debian12_iso_112024_file_id, pbs_122024_file_id, ubuntu22_iso_122024_file_id, ubuntu24_iso_122024_file_id
#     dns_servers        = ["192.168.1.2"] # ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
#     domain             = "local.hommet.net"
#     firewall_enabled   = false
#     hostname           = "infra01"
#     ipv4               = "192.168.1.201/24"
#     net_mac_address    = "BC:24:11:CA:FE:01"
#     net_rate_limit     = 0
#     pool_id            = "prod"
#     ram                = 512
#     start_on_boot      = true
#     started            = true
#     startup_order      = "2"
#     tags               = ["infra", "ubuntu24"]
#     vm_id              = 1201
#   }

#   "docker01" = {
#     cpu_cores          = 2
#     description        = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`, `docker-compose`. Used for Rancher and Ghost blog (temp)."
#     disk_efi_datastore = "zfsvm"
#     disk_size          = 64
#     disk_vm_datastore  = "zfsvm"
#     disk_vm_img        = "ubuntu24_minimal"
#     dns_servers        = ["192.168.1.2"] # ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
#     domain             = "local.hommet.net"
#     firewall_enabled   = false
#     hostname           = "docker01"
#     ipv4               = "192.168.1.202/24"
#     net_mac_address    = "BC:24:11:CA:FE:02"
#     net_rate_limit     = 200
#     pool_id            = "prod"
#     ram                = 6144
#     start_on_boot      = true
#     started            = true
#     startup_order      = "1"
#     tags               = ["docker", "ubuntu24"]
#     vm_id              = 1202
#   }

#   "k3s01" = {
#     cpu_cores          = 4
#     description        = "Managed by OpenTofu. Tools installed: `cockpit`, `k3s`. Lightweight kubernetes cluster."
#     disk_efi_datastore = "zfsvm"
#     disk_size          = 64
#     disk_vm_datastore  = "zfsvm"
#     disk_vm_img        = "ubuntu22_minimal"
#     dns_servers        = ["192.168.1.2"] # ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
#     domain             = "local.hommet.net"
#     firewall_enabled   = false
#     hostname           = "k3s01"
#     ipv4               = "192.168.1.203/24"
#     net_mac_address    = "BC:24:11:CA:FE:03"
#     net_rate_limit     = 0
#     pool_id            = "prod"
#     ram                = 12288
#     start_on_boot      = true
#     started            = true
#     startup_order      = "2"
#     tags               = ["k3s", "ubuntu22"]
#     vm_id              = 1203
#   }
# }

# meta_config_metadata = {
#   "infra01" = <<-EOF
#     instance-id: infra01-instance
#     local-hostname: ups01
#   EOF

# "docker01" = <<-EOF
#   instance-id: docker01-instance
#   local-hostname: docker01
# EOF

# "k3s01" = <<-EOF
#   instance-id: k3s01-instance
#   local-hostname: k3s01
# EOF
# }

# user_cloud_config = {
#   "infra01" = {
#     user_data_path = "cloud-init/infra01.yaml"
#   }
# "docker01" = {
#   user_data_path = "cloud-init/docker01.yaml"
# }
# "k3s01" = {
#   user_data_path = "cloud-init/k3s01.yaml"
# }
# }
