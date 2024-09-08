vm = {
  "docker01" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`, `docker-compose`. Used only for Ghost blog."
    disk_size        = 64
    dns_servers      = ["192.168.1.2"]
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "docker01"
    net_mac_address  = "BC:24:11:CA:FE:01"
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

meta_config_metadata = {
  "docker01" = <<-EOF
    instance-id: docker01-instance
    local-hostname: docker01
  EOF
}

# network_config_metadata = {
#   "docker01" = <<-EOF
#     network:
#       version: 2
#       ethernets:
#         enp6s18:
#           match:
#             macaddress: "BC:24:11:CA:FE:01"
#           addresses:
#             - 192.168.1.201/24
#           routes:
#             - to: 0.0.0.0/0
#               via: 192.168.1.254
#           nameservers:
#             addresses: [192.168.1.2, 1.1.1.1]
#   EOF
# }

cloud_config_scripts = {
  "docker01" = <<-EOF
    #cloud-config

    hostname: docker01
    manage_etc_hosts: true

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

    # Misc settings
    timezone: Europe/Paris
    locale: en_US

    random_seed:
      file: /var/lib/cloud/seed/random-seed
      data: YXBwbGUgbW91bnRhaW4gZ2lyYWZmZSBvY2VhbiBjbG91ZCBqdW5nbGUgbXlzdGVyaWVzIHRodW5kZXIgaG9yaXpvbiBjYWN0dXM=
      encoding: base64

    keyboard:
      layout: fr
      model: pc105

    runcmd:
      - rm -f /etc/machine-id
      - systemd-machine-id-setup
      - rm -f /var/lib/dbus/machine-id
      - ln -s /etc/machine-id /var/lib/dbus/machine-id
      - systemctl restart NetworkManager
      - pacman -Syu --noconfirm
      - pacman -S --noconfirm docker docker-compose ufw
      - ufw allow from 192.168.1.0/24 to any port 22 proto tcp
      - ufw allow from 192.168.1.0/24 to any port 80 proto tcp
      - ufw allow from 192.168.1.0/24 to any port 443 proto tcp
      - ufw allow from 192.168.1.0/24 to any port 9090 proto tcp
      - ufw default deny incoming
      - ufw default allow outgoing
      - systemctl enable docker
      - systemctl start docker
      - usermod -aG docker user
      - mkdir -p /opt/docker
      - chown -R user: /opt/docker
      - ufw --force enable

    write_files:
      - path: /etc/docker/daemon.json
        content: |
          {
            "log-driver": "json-file",
            "log-opts": {
              "max-size": "10m",
              "max-file": "3"
            }
          }

      - path: /etc/sysctl.d/99-sysctl-performance.conf
        content: |
          net.core.somaxconn = 1024
          net.core.netdev_max_backlog = 5000
          net.ipv4.tcp_max_syn_backlog = 8096
          net.ipv4.tcp_slow_start_after_idle = 0
          net.ipv4.tcp_tw_reuse = 1

      - path: /opt/docker/dc-compose.yml
        content: |
          ---
          x-common: &x-common
            <<: *x-logging
            privileged: false
            volumes:
              - /etc/localtime:/etc/localtime:ro
            security_opt:
              - no-new-privileges=true
            tmpfs:
              - /tmp:rw,noexec,nosuid,size=32m
            ulimits:
              nproc: 6144
              nofile:
                soft: 8000
                hard: 12000
          ###
          services:
            traefik:
              <<: *x-common
              container_name: traefik
              image: traefik:v3.1
              restart: always
              networks:
                - monitoring
                - oueb
                - backend
              ports:
                - target: 80
                  published: 80
                  protocol: tcp
                  mode: host
                - target: 443
                  published: 443
                  protocol: tcp
                  mode: host
                - target: 443
                  published: 443
                  protocol: udp
                  mode: host
              environment:
                #- "CF_API_EMAIL=cloudflare.upscale357@passmail.net"
                #- "CF_API_KEY=8d4697a6e80e9d53c2d0e18203692c58"
                - "CF_DNS_API_TOKEN=qofWPBdZhGFXCvvu1RVDZ_WwQz5H-knyPdVC7i7t"
                #- "CF_ZONE_API_TOKEN=gFv3YnuuLFNiqox81qiBO7e9uWCuBxeUL9TJ_ouk"
          #qofWPBdZhGFXCvvu1RVDZ_WwQz5H-knyPdVC7i7t
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock:ro
                - ./conf/traefik.yml:/etc/traefik/traefik.yml:ro
                - ./conf/traefikdynamic:/dynamic
                - ./conf/acme.json:/acme.json
                - ./logs/traefik.log:/etc/traefik/applog.log
                - ./logs/traefikAccess.log:/etc/traefik/access.log
              healthcheck:
                test: ["CMD", "traefik", "healthcheck", "--ping"]
                interval: 10s
                timeout: 5s
                retries: 3
  EOF
}
