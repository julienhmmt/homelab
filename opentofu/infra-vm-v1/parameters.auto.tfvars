vm = {
  "tesla" = {
    cpu_cores          = 1
    description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nut`. MV utilisée seulement pour exploiter l'onduleur en USB."
    disk_efi_datastore = "local-nvme"
    disk_size          = 32
    disk_vm_datastore  = "local-nvme"
    dns_servers        = ["192.168.1.254"]
    domain             = "dc.prive.local.hommet.net"
    firewall_enabled   = false
    hostname           = "tesla"
    ipv4               = "192.168.1.31"
    net_mac_address    = "BC:24:11:CA:FE:31"
    net_rate_limit     = 100
    os                 = "ubuntu24" # "debian12", "almalinux95", "archlinux", "ubuntu22", "ubuntu24"
    pool_id            = "prod"
    ram                = 1024
    start_on_boot      = true
    started            = true
    startup_order      = "2"
    tags               = ["infra", "ubuntu24"]
    vm_id              = 1031
  }

  # "charger" = {
  #   cpu_cores          = 1
  #   description        = "Managed by OpenTofu. Tools installed: `cockpit`, `nfs-kernel-server`. MV utilisée seulement pour le stockage NFS des machines et des conteneurs."
  #   disk_efi_datastore = "local-nvme"
  #   disk_size          = 48
  #   disk_vm_datastore  = "local-nvme"
  #   dns_servers        = ["192.168.1.254"]
  #   domain             = "dc.prive.local.hommet.net"
  #   firewall_enabled   = false
  #   hostname           = "charger"
  #   ipv4               = "192.168.1.32"
  #   net_mac_address    = "BC:24:11:CA:FE:32"
  #   net_rate_limit     = 0
  #   os                 = "ubuntu24" # "debian12", "almalinux95", "archlinux", "ubuntu22", "ubuntu24"
  #   pool_id            = "prod"
  #   ram                = 1024
  #   start_on_boot      = true
  #   started            = true
  #   startup_order      = "1"
  #   tags               = ["infra", "ubuntu24"]
  #   vm_id              = 132
  # }

  # "challenger" = {
  #   cpu_cores          = 1
  #   description        = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`. MV utilisée pour `gitea` et `vault`."
  #   disk_efi_datastore = "zfs_nvme"
  #   disk_size          = 32
  #   disk_vm_datastore  = "zfs_nvme"
  #   dns_servers        = ["192.168.1.254"]
  #   domain             = "dc.prive.local.hommet.net"
  #   firewall_enabled   = false
  #   hostname           = "challenger"
  #   ipv4               = "192.168.1.22/24"
  #   net_mac_address    = "BC:24:11:CA:FE:22"
  #   net_rate_limit     = 100
  #   pool_id            = "prod"
  #   ram                = 4096
  #   start_on_boot      = true
  #   started            = true
  #   startup_order      = "1"
  #   tags               = ["debian12", "infra", "podman"]
  #   vm_id              = 991122
  # }
}

meta_config_metadata = {
  "tesla" = <<-EOF
    instance-id: tesla-instance
    local-hostname: tesla
  EOF

  "charger" = <<-EOF
    instance-id: charger-instance
    local-hostname: charger
  EOF

  "challenger" = <<-EOF
    instance-id: challenger-instance
    local-hostname: challenger
  EOF
}

user_cloud_config = {
  "tesla" = "cloud-init/tesla.yml"
  # "charger" = "cloud-init/charger.yml"
}
