vm = {
  "testvm" = {
    cpu_cores        = 1
    description      = "Managed by OpenTofu. Hashicorp Vault, internal PKI + secrets manager"
    disk_size        = 16
    domain           = "khepri.internal"
    firewall_enabled = false
    hostname         = "vault"
    id               = 1201
    ipv4_address     = "192.168.1.201/24"
    net_mac_address  = "BC:24:11:CA:FE:01"
    net_rate_limit   = 100
    pool_id          = "dev"
    ram              = 512
    start_on_boot    = true
    started          = true
    startup_order    = "10"
    tags             = ["arch", "prod"]
    vm_id            = 1201
  }
}

cloud_config_scripts = {
  "testvm" = <<-EOF
    #cloud-config
    packages:
      - qemu-guest-agent
  EOF
}
