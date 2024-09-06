vm = {
  "podman01" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Tools installed: `podman`. Used only for Rancher."
    disk_size        = 32
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "podman01"
    ipv4_address     = "192.168.1.201/24"
    net_mac_address  = "BC:24:11:B0:55:01"
    net_rate_limit   = 200
    pool_id          = "prod"
    ram              = 4096
    start_on_boot    = true
    started          = true
    startup_order    = "2"
    tags             = ["podman"]
    vm_id            = 1201
  }

  "k3sm01" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Tools installed: `k3s`. Used for K3S - MASTER 01"
    disk_size        = 64
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "k3sm01"
    ipv4_address     = "192.168.1.202/24"
    net_mac_address  = "BC:24:11:B0:55:02"
    net_rate_limit   = 0
    pool_id          = "prod"
    ram              = 4096
    start_on_boot    = true
    started          = true
    startup_order    = "1"
    tags             = ["k3s"]
    vm_id            = 1202
  }

  "k3sw01" = {
    cpu_cores        = 4
    description      = "Managed by OpenTofu. Tools installed: `k3s`. Used for K3S - WORKER 01"
    disk_size        = 128
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "k3sw01"
    ipv4_address     = "192.168.1.203/24"
    net_mac_address  = "BC:24:11:B0:55:03"
    net_rate_limit   = 0
    pool_id          = "prod"
    ram              = 12248
    start_on_boot    = true
    started          = true
    startup_order    = "2"
    tags             = ["k3s"]
    vm_id            = 1203
  }
}

cloud_config_metadata = {
  "podman01" = <<-EOF
    instance-id: podman01-instance
    local-hostname: podman01
  EOF

  "k3sm01" = <<-EOF
    instance-id: k3sm01-instance
    local-hostname: k3sm01
  EOF

  "k3sw01" = <<-EOF
    instance-id: k3sw01-instance
    local-hostname: k3sw01
  EOF
}

cloud_config_scripts = {
  "podman01" = <<-EOF
    #cloud-config

    hostname: podman01
    manage_etc_hosts: true

    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    packages:
      - podman
      - qemu-guest-agent

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

    write_files:
      - path: /root/setup-rancher.sh
        permissions: '0755'
        content: |
          #!/bin/bash
          set -e

          # Create necessary directories
          mkdir -p /opt/rancher
          mkdir -p /var/log/rancher/auditlog

          # Check if the Rancher container is already running
          if podman ps --format '{{.Names}}' | grep -q '^rancher$'; then
            echo "Rancher container is already running."
            # Log the bootstrap password
            podman logs rancher 2>&1 | grep "Bootstrap Password:" > /root/bootstrap_pwd.txt
          else
            # Run the Rancher container
            podman run -d --name rancher --restart=always \
              -p 8443:443 \
              -p 8080:80 \
              --privileged \
              -v /opt/rancher:/var/lib/rancher \
              -v /var/log/rancher/auditlog:/var/log/auditlog \
              -e AUDIT_LEVEL=1 \
              docker.io/rancher/rancher:v2.9.1

            timeout=300  # 5 minutes
            elapsed=0
            while true; do
              state=$(podman inspect -f '{{.State.Status}}' rancher)
              if [ "$state" == "running" ]; then
                echo "Rancher container is up and running."
                # Log the bootstrap password
                podman logs rancher 2>&1 | grep "Bootstrap Password:" > /root/bootstrap_pwd.txt
                break
              fi
              if [ "$elapsed" -ge "$timeout" ]; then
                echo "Timeout waiting for Rancher container to start."
                exit 1
              fi
              echo "Waiting for Rancher container to be up..."
              sleep 10
              elapsed=$((elapsed + 10))
            done
          fi

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

  "k3sm01" = <<-EOF
    #cloud-config

    hostname: k3sm01
    manage_etc_hosts: true

    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent

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

    runcmd:
      - mkdir -p /etc/rancher/k3s
      - mkdir -p /var/lib/rancher/k3s
      - chown -R user: /opt/rancher
      - ufw allow OpenSSH

    # Set password policies
    chpasswd:
      expire: false
      list: |
        user:user
    
    # Misc settings
    timezone: Europe/Paris

    random_seed:
      file: /var/lib/cloud/seed/random-seed
      data: TWVhZG93LCBGYWxjb24sIENlcnVsZWFuLCBFdXBob3JpYSwgTXVmZmluLCBEcmFnb24sIFdoaW1zeSwgQ2FzY2FkZSwgT3R0ZXIsIENyaW1zb24sIFNlcmVuZGlwaXR5LCBUYWNvLCBFbGl4aXIsIEhvcml6b24=
      encoding: base64

    power_state:
      condition: true
      delay: now
      message: Rebooting now
      mode: reboot
      timeout: 15

    locale: en_US

    keyboard:
      layout: fr
      model: pc105
  EOF

  "k3sw01" = <<-EOF
    #cloud-config

    hostname: k3sw01
    manage_etc_hosts: true

    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent

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

    runcmd:
      - mkdir -p /etc/rancher/k3s
      - mkdir -p /var/lib/rancher/k3s
      - chown -R user: /opt/rancher
      - ufw allow OpenSSH

    # Set password policies
    chpasswd:
      expire: false
      list: |
        user:user
    
    # Misc settings
    timezone: Europe/Paris

    random_seed:
      file: /var/lib/cloud/seed/random-seed
      data: V2hpc3BlciwgR2FsYXh5LCBFbWJlciwgQ2FzY2FkZSwgTHVtaW5vdXMsIFNlcmVuZGlwaXR5LCBFY2hvLCBWZWx2ZXQsIEhvcml6b24sIE1vc2FpYywgVHdpbGlnaHQsIFByaXNtLCBTb2xzdGljZQ==
      encoding: base64

    power_state:
      condition: true
      delay: now
      message: Rebooting now
      mode: reboot
      timeout: 15

    locale: en_US

    keyboard:
      layout: fr
      model: pc105
  EOF
}
