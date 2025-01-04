vm = {
  "tesla" = {
    cpu_cores          = 1
    description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. MV utilisée seulement pour exploiter l'onduleur en USB."
    disk_efi_datastore = "local-nvme-vm"
    disk_size          = 16
    disk_vm_datastore  = "local-nvme-vm"
    disk_vm_img        = "ubuntu24"
    dns_servers        = ["192.168.1.2"]
    domain             = "dc.prive.local.hommet.net"
    firewall_enabled   = false
    hostname           = "tesla"
    ipv4               = "192.168.1.199/24"
    net_mac_address    = "BC:24:11:CA:FE:99"
    net_rate_limit     = 0
    pool_id            = "prod"
    ram                = 1024
    start_on_boot      = true
    started            = true
    startup_order      = "1"
    tags               = ["infra", "ubuntu24"]
    vm_id              = 991199
  }

  "challenger" = {
    cpu_cores          = 1
    description        = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`. MV utilisée pour `gitea` et `vault`."
    disk_efi_datastore = "local-nvme-vm"
    disk_size          = 32
    disk_vm_datastore  = "local-nvme-vm"
    disk_vm_img        = "ubuntu24"
    dns_servers        = ["192.168.1.2"]
    domain             = "dc.prive.local.hommet.net"
    firewall_enabled   = false
    hostname           = "challenger"
    ipv4               = "192.168.1.198/24"
    net_mac_address    = "BC:24:11:CA:FE:98"
    net_rate_limit     = 100
    pool_id            = "prod"
    ram                = 4096
    start_on_boot      = true
    started            = true
    startup_order      = "1"
    tags               = ["docker", "infra", "ubuntu24"]
    vm_id              = 991198
  }
}

meta_config_metadata = {
  "tesla" = <<-EOF
    instance-id: tesla-instance
    local-hostname: tesla
  EOF

  "challenger" = <<-EOF
    instance-id: challenger-instance
    local-hostname: challenger
  EOF
}

user_cloud_config = {
  "tesla" = {
    user_data_path = "cloud-init/tesla.yaml"
  }

  "challenger" = {
    user_data_path = "cloud-init/challenger.yaml"
  }
}
