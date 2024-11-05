ct = {
  "vault" = {
    cpu_cores        = 1
    description      = "Managed by OpenTofu. Hashicorp Vault, internal PKI + secrets manager"
    disk_size        = 16
    domain           = "local.hommet.net"
    hostname         = "vault"
    id               = 1201
    ipv4             = "192.168.1.201/24"
    net_mac_address  = "BC:24:11:CA:FE:01"
    net_rate_limit   = 100
    pool_id          = "prod"
    ram              = 512
    start_on_boot    = true
    startup_order    = 1
    startup_up_delay = 5
    swap             = 0
    tags             = ["arch", "ct", "prod"]
    unprivileged     = true
  }

  "redis" = {
    cpu_cores        = 1
    description      = "Managed by OpenTofu. Redis"
    disk_size        = 16
    domain           = "local.hommet.net"
    hostname         = "redis"
    id               = 1202
    ipv4             = "192.168.1.202/24"
    net_mac_address  = "BC:24:11:CA:FE:02"
    net_rate_limit   = 0
    pool_id          = "prod"
    ram              = 2048
    start_on_boot    = true
    startup_order    = 1
    startup_up_delay = 5
    swap             = 2048
    tags             = ["arch", "ct", "db", "prod"]
    unprivileged     = true
  }

  "influxdb" = {
    cpu_cores           = 1
    description         = "Managed by OpenTofu. InfluxDB"
    disk_size           = 16
    domain              = "khepri.internal"
    hook_script_file_id = "local:snippets/script2.sh"
    hostname            = "influxdb"
    id                  = 1203
    ipv4                = "192.168.1.203/24"
    net_mac_address     = "BC:24:11:CA:FE:03"
    net_rate_limit      = 0
    pool_id             = "prod"
    ram                 = 1024
    start_on_boot       = true
    startup_order       = 1
    startup_up_delay    = 5
    swap                = 0
    tags                = ["ct", "db", "debian12", "prod"]
    unprivileged        = true
  }


  "cloudflaretunnel" = {
    cpu_cores           = 1
    description         = "Managed by OpenTofu. CloudFlare tunnel for public access from the web."
    disk_size           = 16
    domain              = "khepri.internal"
    hook_script_file_id = "local:snippets/script1.sh"
    hostname            = "cftpublic"
    id                  = 1206
    ipv4                = "192.168.1.206/24"
    net_mac_address     = "BC:24:11:CA:FE:06"
    net_rate_limit      = 100
    pool_id             = "prod"
    ram                 = 512
    start_on_boot       = true
    startup_order       = 3
    startup_up_delay    = 5
    swap                = 0
    tags                = ["ct", "debian12", "prod"]
    unprivileged        = true
  }

  "authentik" = {
    cpu_cores           = 1
    description         = "Managed by OpenTofu. IAM"
    disk_size           = 16
    domain              = "khepri.internal"
    hook_script_file_id = "local:snippets/script1.sh"
    hostname            = "authentik"
    id                  = 1207
    ipv4                = "192.168.1.207/24"
    net_mac_address     = "BC:24:11:CA:FE:07"
    net_rate_limit      = 100
    pool_id             = "prod"
    ram                 = 512
    start_on_boot       = true
    startup_order       = 5
    startup_up_delay    = 5
    swap                = 0
    tags                = ["ct", "debian12", "iam", "prod"]
    unprivileged        = true
  }
}
