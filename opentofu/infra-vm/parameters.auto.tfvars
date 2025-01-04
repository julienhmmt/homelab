vm = {
  "tesla" = {
    cpu_cores          = 1
    description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. Used only for infra services."
    disk_efi_datastore = "local-nvme-vm"
    disk_size          = 16
    disk_vm_datastore  = "local-nvme-vm"
    disk_vm_img        = "ubuntu24"
    dns_servers        = ["192.168.1.2"]
    domain             = "dc.prive.local.hommet.net"
    firewall_enabled   = false
    hostname           = "tesla"
    ipv4               = "192.168.1.199/24"
    net_mac_address    = "BC:24:11:CA:FE:11"
    net_rate_limit     = 0
    pool_id            = "prod"
    ram                = 1024
    start_on_boot      = true
    started            = true
    startup_order      = "1"
    tags               = ["infra", "ubuntu24"]
    vm_id              = 991199
  }

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
}

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
