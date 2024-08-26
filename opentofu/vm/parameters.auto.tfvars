vm = {
  "testvm" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Hashicorp Vault, internal PKI + secrets manager"
    disk_size        = 16
    domain           = "khepri.internal"
    firewall_enabled = false
    hostname         = "testvm"
    ipv4_address     = "192.168.1.201/24"
    net_mac_address  = "BC:24:11:CA:FE:01"
    net_rate_limit   = 100
    pool_id          = "dev"
    ram              = 2048
    start_on_boot    = false
    started          = true
    startup_order    = "10"
    tags             = ["arch", "test"]
    vm_id            = 9999
  }
}

cloud_config_metadata = {
  "testvm" = <<-EOF
    instance-id: testvm-instance
    local-hostname: testvm
  EOF
}

cloud_config_scripts = {
  "testvm" = <<-EOF
    #cloud-config

    hostname: testvm
    manage_etc_hosts: true

    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent

    # default password = user
    users:
      - name: user
        passwd: $6$rounds=4096$saltsalt$Qx5vTv.3oeF4.hPtzS/bwQm9J8NX6hSt1XPe2vAaAHCVrnwo.UEjH/EWFu1UvFBVIKV1Q4vlJZBhM6HxPJI5e1
        lock_passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: wheel
        shell: /bin/bash

    runcmd:
      - systemctl enable qemu-guest-agent

    # Set password policies
    chpasswd:
      expire: false
      list: |
        user:user

    ssh_pwauth: true
  EOF
}
