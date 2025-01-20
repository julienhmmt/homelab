vm = {
  "nix-test" = {
    cpu_cores          = 1
    description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. MV utilisée seulement pour exploiter l'onduleur en USB."
    disk_efi_datastore = "local-nvme-vm"
    disk_size          = 32
    disk_vm_datastore  = "local-nvme-vm"
    # disk_vm_img        = "ubuntu24"
    dns_servers      = ["1.1.1.1"]
    domain           = "dc.prive.local.hommet.net"
    firewall_enabled = false
    hostname         = "nix-test"
    ipv4             = "192.168.1.49/24"
    net_mac_address  = "BC:24:11:CA:FE:11"
    net_rate_limit   = 0
    pool_id          = "temp"
    ram              = 2048
    start_on_boot    = true
    started          = true
    startup_order    = "1"
    tags             = ["infra", "nixos"]
    vm_id            = 991111
  }
}

# meta_config_metadata = {
#   "tesla" = <<-EOF
#     instance-id: tesla-instance
#     local-hostname: tesla
#   EOF
# }

# user_cloud_config = {
#   "tesla" = {
#     user_data_path = "cloud-init/tesla.yaml"
#   }
# }
