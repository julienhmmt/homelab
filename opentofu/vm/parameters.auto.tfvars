vm = {
  "docker01" = {
    cpu_cores        = 2
    description      = "Managed by OpenTofu. Tools installed: `cockpit`, `docker`, `docker-compose`. Used only for Ghost blog."
    disk_size        = 64
    dns_servers      = ["192.168.1.2", "1.1.1.1", "1.0.0.1"]
    domain           = "local.hommet.net"
    firewall_enabled = false
    hostname         = "docker01"
    net_mac_address  = "BC:24:11:CA:FE:01"
    net_rate_limit   = 200
    pool_id          = "prod"
    ram              = 6144
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
      - systemctl enable docker
      - systemctl start docker
      - usermod -aG docker user
      - mkdir -p /opt/docker/rancher/{data,auditlog}
      - mkdir -p /opt/docker/traefik/{logs,traefikdynamic}
      - mkdir -p /opt/docker/portainer/data
      - touch /opt/docker/traefik/{acme-dev.json,acme-prod.json}
      - touch /opt/docker/traefik/logs/{traefik.log,traefikAccess.log}
      - chmod 600 /opt/docker/traefik/{acme-dev.json,acme-prod.json}
      - chown -R user:user /opt/docker
      - docker network create -d bridge oueb --subnet 172.16.1.0/24
      - docker network create -d bridge monitoring --subnet 172.16.2.0/24
      - docker network create -d bridge socket_proxy --subnet 172.16.3.0/24

    write_files:
      - path: /etc/sysctl.d/99-sysctl-performance.conf
        content: |
          net.core.somaxconn = 1024
          net.core.netdev_max_backlog = 5000
          net.ipv4.tcp_max_syn_backlog = 8096
          net.ipv4.tcp_slow_start_after_idle = 0
          net.ipv4.tcp_tw_reuse = 1

      - path: /etc/logrotate.d/traefik
        content: |
          /opt/docker/traefik/logs/traefik*.log {
            daily
            rotate 30
            missingok
            notifempty
            dateext
            dateformat .%Y-%m-%d
            create 0644 user user
            postrotate
            docker kill --signal="USR1" $(docker ps | grep traefik | awk '{print $1}')
            endscript
          }

      - path: /opt/docker/dc-compose.yml
        content: |
          ---
          x-common: &x-common
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
            logging:
              options:
                max-size: "10m"
                max-file: "3"
          ###
          services:
            socket-proxy:
              image: tecnativa/docker-socket-proxy
              container_name: socket-proxy
              restart: unless-stopped
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock:ro
              environment:
                - CONTAINERS=1
                - IMAGES=1
                - INFO=1
                - NETWORKS=1
                - SERVICES=1
                - VOLUMES=1
              networks:
                - socket_proxy
              mem_limit: 128m
              mem_reservation: 64m
              memswap_limit: 128m

            traefik:
              <<: *x-common
              container_name: traefik
              image: traefik:comte
              restart: always
              networks:
                - backend
                - monitoring
                - oueb
                - socket_proxy
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
                - "CLOUDFLARE_EMAIL=cloudflare.upscale357@passmail.net"
                - "CLOUDFLARE_API_KEY=6f039849debd9a90083ade39dc32a14799907"
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock:ro
                - /opt/docker/traefik/traefik.yml:/etc/traefik/traefik.yml:ro
                - /opt/docker/traefik/traefikdynamic:/dynamic
                - /opt/docker/traefik/acme-dev.json:/acme-dev.json
                - /opt/docker/traefik/acme-prod.json:/acme-prod.json
                - /opt/docker/traefik/logs/traefik.log:/etc/traefik/applog.log
                - /opt/docker/traefik/logs/traefikAccess.log:/etc/traefik/access.log
              healthcheck:
                test: ["CMD", "traefik", "healthcheck", "--ping"]
                interval: 10s
                timeout: 5s
                retries: 3
              mem_limit: 256m
              mem_reservation: 128m
              memswap_limit: 256m
              depends_on:
                - socket-proxy
          ###
            rancher:
              <<: *x-common
              container_name: rancher
              image: rancher/rancher:v2.9.1
              restart: always
              privileged: true
              networks:
                - backend
              environment:
                - "AUDIT_LEVEL=1"
              volumes:
                - /opt/docker/rancher/auditlog:/var/log/auditlog
                - /opt/docker/rancher/data:/var/lib/rancher
          ###
            portainer:
              <<: *x-common
              container_name: portainer
              image: portainer/portainer-ce:alpine
              restart: unless-stopped
              command: -H tcp://socket-proxy:2375
              networks:
                - socket_proxy
              volumes:
                - /opt/docker/portainer/data:/data
              depends_on:
                - socket-proxy
              mem_limit: 256m
              mem_reservation: 128m
              memswap_limit: 256m

          networks:
            backend:

            oueb:
              external: true
              name: oueb

            monitoring:
              external: true
              name: monitoring

            socket_proxy:
              external: true
              name: socket_proxy

      - path: /opt/docker/traefik/traefik.yml
        content: |
          ---
          global:
            sendAnonymousUsage: true
            checkNewVersion: false

          api:
            dashboard: true
            insecure: true

          log:
            level: INFO
            filePath: "/etc/traefik/applog.log"
            format: common

          accessLog:
            filePath: "/etc/traefik/access.log"
            bufferingSize: 200
            fields:
              defaultMode: keep
              names:
                ClientUsername: drop
              headers:
                defaultMode: keep
                names:
                    User-Agent: keep
                    Authorization: drop
                    Content-Type: keep
                    Duration: keep
                    RemoteAddr: keep

          providers:
            docker:
              endpoint: tcp://socket-proxy:2375
              exposedByDefault: false
              watch: true
            file:
              directory: "/dynamic"
              watch: true

          entryPoints:
            web:
              address: :80
              http:
                redirections:
                  entryPoint:
                    to: websecure
                    scheme: https
                    permanent: true
            websecure:
              address: :443
              http3:
                advertisedPort: 443
            metrics:
              address: ":9090"
            ping:
              address: ":8082"

          ping:
            entryPoint: "ping"

          certificatesResolvers:
            # staging LETSENCRYPT
            dev:
              acme:
                caServer: https://acme-staging-v02.api.letsencrypt.org/directory
                email: cloudflare.upscale357@passmail.net
                keyType: EC256
                storage: acme-dev.json
                tlsChallenge: {}
            # production CLOUDFLARE
            prod:
              acme:
                email: cloudflare.upscale357@passmail.net
                keyType: EC256
                storage: acme-prod.json
                dnsChallenge:
                  provider: cloudflare
                  resolvers:
                    - "1.1.1.1:53"
                    - "1.0.0.1:53"
          metrics:
            prometheus:
              entryPoint: metrics
              addEntryPointsLabels: true
              addRoutersLabels: true
              addServicesLabels: true

      - path: /opt/docker/traefik/traefikdynamic/rancher.yml
        content: |
          ---
          http:
            services:
              sc-rancher:
                loadBalancer:
                  servers:
                    - url: "http://rancher:80"
            routers:
              rt-rancher:
                entryPoints:
                  - websecure
                service: sc-rancher
                rule: Host (`rancher.local.cloudathome.dev`)
                tls:
                  certResolver: prod

      - path: /opt/docker/traefik/traefikdynamic/portainer.yml
        content: |
          ---
          http:
            services:
              sc-portainer:
                loadBalancer:
                  servers:
                    - url: "http://portainer:9000"
            routers:
              rt-portainer:
                entryPoints:
                  - websecure
                service: sc-portainer
                rule: Host (`portainer.local.cloudathome.dev`)
                tls:
                  certResolver: prod
  EOF
}
