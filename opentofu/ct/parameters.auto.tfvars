# ct = {
#   "vault" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. Hashicorp Vault, internal PKI + secrets manager"
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/update_upgrade.pl"
#     hostname            = "vault"
#     id                  = 1201
#     ipv4                = "192.168.1.201/24"
#     net_mac_address     = "BC:24:11:CA:FE:01"
#     net_rate_limit      = 100
#     pool_id             = "prod"
#     ram                 = 512
#     start_on_boot       = true
#     startup_order       = 1
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "debian12", "prod"]
#     unprivileged        = true
#   }

#   # "netdata" = {
#   #   cpu_cores        = 1
#   #   description      = "Managed by OpenTofu. PVE supervision"
#   #   disk_size        = 16
#   #   domain           = "khepri.internal"
#   #   hook_script_file_id = "local:snippets/script1.sh"
#   #   hostname         = "netdata"
#   #   id               = 1202
#   #   ipv4             = "192.168.1.202/24"
#   #   net_mac_address  = "BC:24:11:CA:FE:02"
#   #   net_rate_limit   = 100
#   #   pool_id          = "prod"
#   #   ram              = 512
#   #   start_on_boot    = true
#   #   startup_order    = 2
#   #   startup_up_delay = 5
#   #   swap             = 0
#   #   tags             = ["ct", "debian12", "monitoring", "prod"]
#   #   unprivileged     = true
#   # }

#   "influxdb" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. InfluxDB"
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script2.sh"
#     hostname            = "influxdb"
#     id                  = 1203
#     ipv4                = "192.168.1.203/24"
#     net_mac_address     = "BC:24:11:CA:FE:03"
#     net_rate_limit      = 0
#     pool_id             = "prod"
#     ram                 = 1024
#     start_on_boot       = true
#     startup_order       = 1
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "db", "debian12", "prod"]
#     unprivileged        = true
#   }

#   "redis" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. Redis"
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script1.sh"
#     hostname            = "redis"
#     id                  = 1204
#     ipv4                = "192.168.1.204/24"
#     net_mac_address     = "BC:24:11:CA:FE:04"
#     net_rate_limit      = 0
#     pool_id             = "prod"
#     ram                 = 2048
#     start_on_boot       = true
#     startup_order       = 1
#     startup_up_delay    = 5
#     swap                = 2048
#     tags                = ["ct", "db", "debian12", "prod"]
#     unprivileged        = true
#   }

#   "haproxy" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. HAProxy for public and internal access."
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script1.sh"
#     hostname            = "haproxy"
#     id                  = 1205
#     ipv4                = "192.168.1.205/24"
#     net_mac_address     = "BC:24:11:CA:FE:05"
#     net_rate_limit      = 0
#     pool_id             = "prod"
#     ram                 = 512
#     start_on_boot       = true
#     startup_order       = 3
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "debian12", "prod", "rp"]
#     unprivileged        = true
#   }

#   "cloudflaretunnel" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. CloudFlare tunnel for public access from the web."
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script1.sh"
#     hostname            = "cftpublic"
#     id                  = 1206
#     ipv4                = "192.168.1.206/24"
#     net_mac_address     = "BC:24:11:CA:FE:06"
#     net_rate_limit      = 100
#     pool_id             = "prod"
#     ram                 = 512
#     start_on_boot       = true
#     startup_order       = 3
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "debian12", "prod"]
#     unprivileged        = true
#   }

#   "authentik" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. IAM"
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script1.sh"
#     hostname            = "authentik"
#     id                  = 1207
#     ipv4                = "192.168.1.207/24"
#     net_mac_address     = "BC:24:11:CA:FE:07"
#     net_rate_limit      = 100
#     pool_id             = "prod"
#     ram                 = 512
#     start_on_boot       = true
#     startup_order       = 5
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "debian12", "iam", "prod"]
#     unprivileged        = true
#   }

#   "teleport" = {
#     cpu_cores           = 1
#     description         = "Managed by OpenTofu. Bastion"
#     disk_size           = 16
#     domain              = "khepri.internal"
#     hook_script_file_id = "local:snippets/script1.sh"
#     hostname            = "teleport"
#     id                  = 1208
#     ipv4                = "192.168.1.208/24"
#     net_mac_address     = "BC:24:11:CA:FE:08"
#     net_rate_limit      = 100
#     pool_id             = "prod"
#     ram                 = 512
#     start_on_boot       = true
#     startup_order       = 2
#     startup_up_delay    = 5
#     swap                = 0
#     tags                = ["ct", "debian12", "bastion", "prod"]
#     unprivileged        = true
#   }
# }

# hook_scripts = {
#   "script1.sh" = <<-EOF
#     #!/bin/bash
#     echo "Running prepare hook script"
#     apt update
#     apt upgrade -y
#     apt autoremove -y
#   EOF

#   "script2.sh" = <<-EOF
#     #!/bin/bash
#     echo "Win !"
#   EOF

#   "update_upgrade.pl" = <<-EOF
#     #!/usr/bin/perl

#     use strict;
#     use warnings;

#     print "Starting container update and upgrade process...\n";

#     print "Running apt update...\n";
#     system("apt update") == 0
#         or die "Failed to run apt update: $?";

#     print "Running apt upgrade...\n";
#     system("apt upgrade -y") == 0
#         or die "Failed to run apt upgrade: $?";

#     print "Container update and upgrade process completed successfully.\n";
#   EOF
# }