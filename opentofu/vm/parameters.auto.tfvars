vm = {
  "docker01" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`, `docker-compose`. Used only for Ghost blog."
    disk_size        = 64
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "docker01"
    ipv4_address     = "192.168.1.201/24"
    net_mac_address  = "BC:24:11:B0:55:01"
    net_rate_limit   = 200
    pool_id          = "prod"
    ram              = 4096
    start_on_boot    = true
    started          = true
    startup_order    = "2"
    tags             = ["arch", "docker"]
    vm_id            = 1201
  }
}

cloud_config_metadata = {
  "docker01" = <<-EOF
    instance-id: docker01-instance
    local-hostname: docker01
  EOF
}

cloud_config_scripts = {
  "docker01" = <<-EOF
    #cloud-config

    hostname: docker01
    manage_etc_hosts: true

    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    packages:
      - docker
      - docker-compose
      - ufw

    allow_public_ssh_keys: true
    ssh_pwauth: true
    ssh_quiet_keygen: true

    # default password = user
    users:
      - name: user
        passwd: $6$rounds=4096$saltsalt$Qx5vTv.3oeF4.hPtzS/bwQm9J8NX6hSt1XPe2vAaAHCVrnwo.UEjH/EWFu1UvFBVIKV1Q4vlJZBhM6HxPJI5e1
        lock_passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: wheel
        shell: /bin/bash

    # Set password policies
    chpasswd:
      expire: false
      list: |
        user:user

    # Misc settings
    timezone: Europe/Paris

    random_seed:
      file: /var/lib/cloud/seed/random-seed
      data: YXBwbGUgbW91bnRhaW4gZ2lyYWZmZSBvY2VhbiBjbG91ZCBqdW5nbGUgbXlzdGVyaWVzIHRodW5kZXIgaG9yaXpvbiBjYWN0dXM=
      encoding: base64

    locale: en_US
    keyboard:
      layout: fr
      model: pc105

    runcmd:
      - ufw allow OpenSSH
  EOF
}
