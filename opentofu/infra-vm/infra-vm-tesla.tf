# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_tesla" {
  length  = 24
  special = true
}

output "vm_root_password_tesla" {
  value     = random_password.vm_root_password_tesla.result
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_tesla" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      instance-id: tesla-instance
      local-hostname: tesla
    EOF
    file_name = "tesla_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config_tesla" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      #cloud-config

      hostname: tesla
      manage_etc_hosts: true

      allow_public_ssh_keys: true
      ssh_quiet_keygen: true

      users:
        - name: root
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10

        - name: jhoadmin
          groups: wheel
          lock_passwd: false
          passwd: $6$rounds=500000$tAy4OxDkBy61IO3n$qMZ5IBOoMUvXAgIB4PYkaZzZlalE4Ez0XOb9AYP1dCyK9WsxE4ySFLd2HacSdgaPLakcks5bGmDVo/r7O0H9r1
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10
          sudo: ALL=(ALL) NOPASSWD:ALL

      # Misc settings
      locale: en_US.UTF-8
      package_update: false # because we will update the system in the runcmd section (pacman instead of apt)
      package_upgrade: false
      timezone: Europe/Paris

      runcmd:
        - rm -f /etc/machine-id
        - rm -f /var/lib/dbus/machine-id
        - ln -s /etc/machine-id /var/lib/dbus/machine-id
        - swapoff -a
        - sed -i 's|^/swap/swapfile|#/swap/swapfile|' /etc/fstab
        - pacman -Syu --noconfirm bash-completion cloud-guest-utils extra/cockpit curl extra/cockpit-storaged less libiscsi libusb nano extra/netdata extra/nut pcp qemu-guest-agent udisks2-btrfs vim

        # DEBUT // NUT configuration
        - mv /etc/nut/upsd.users /etc/nut/upsd.users.doc
        - sed -i 's/MODE=none/MODE=standalone/' /etc/nut/nut.conf
        - echo -e "[admin]\npassword = your_password\nactions = SET\ninstcmds = ALL\nupsmon master" >> /etc/nut/upsd.users
        - echo "NOTIFYCMD /usr/sbin/upssched" >> /etc/nut/upsmon.conf
        - echo "MONITOR nutdev1@localhost 1 admin pouetpouet master" >> /etc/nut/upsmon.conf
        # FIN // NUT configuration

        # DEBUT // Pacman configuration
        - sed -i '/\[options\]/a ILoveCandy' /etc/pacman.conf
        - sed -i 's/#Color/Color/' /etc/pacman.conf
        - sed -i 's/#TotalDownload/TotalDownload/' /etc/pacman.conf
        - sed -i 's/#CacheDir/\CacheDir/' /etc/pacman.conf
        - sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
        - sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
        - sed -i 's/#CheckSpace/CheckSpace/' /etc/pacman.conf
        - sed -i 's/#CleanMethod/CleanMethod/' /etc/pacman.conf
        # FIN // Pacman configuration

        - systemctl enable --now --all cockpit.socket netdata.service nut-driver-enumerator.service nut-server.service
        - rm /etc/motd.d/cockpit /etc/issue.d/cockpit.issue
        - systemctl stop --all
        - reboot -f

      write_files:
      - path: /etc/nut/ups.conf
        content: |
          maxretry = 3
          [nutdev1]
            driver = "usbhid-ups"
            port = "auto"

      - path: /etc/nut/upsd.users
        content: |
          [admin]
          password = pouetpouet
          actions = SET
          instcmds = ALL
          upsmon master
    EOF
    file_name = "tesla_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "onduleur" {
  comment = "UPS Eaton 3S"
  name    = "onduleur"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "miniquarium"
    },
  ]
}

resource "proxmox_virtual_environment_vm" "vm_tesla" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_tesla,
    proxmox_virtual_environment_file.user_cloud_config_tesla,
    random_password.vm_root_password_tesla
  ]

  lifecycle { ignore_changes = [] }

  boot_order      = ["scsi0"]
  bios            = "ovmf"
  description     = "Tesla VM. Services installés : `cockpit`, `nut`."
  keyboard_layout = "fr"
  machine         = "pc-q35-9.0"
  migrate         = true
  name            = "tesla"
  node_name       = "miniquarium"
  on_boot         = true
  # pool_id             = each.value.pool_id
  reboot_after_update = false
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  stop_on_destroy     = true
  tablet_device       = false
  tags                = ["arch", "infra", "vm"]
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = 131

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = 1
    flags   = []
    numa    = true
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = "local-nvme"
    discard      = "on"
    file_id      = "local:iso/Arch-Linux-x86_64-cloudimg.img"
    iothread     = true
    interface    = "scsi0"
    replicate    = false
    size         = 24
  }

  efi_disk {
    datastore_id      = "local-nvme"
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = "local-nvme"

    dns {
      domain  = "dc.local.hommet.net"
      servers = ["192.168.1.254", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.31/24"
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_tesla.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_tesla.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    mac_address  = "BC:24:11:CA:FE:31"
    rate_limit   = 100
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = 5
    up_delay   = 5
    down_delay = 60
  }

  usb {
    mapping = "onduleur"
    usb3    = false
  }

  tpm_state {
    datastore_id = "local-nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}

resource "proxmox_virtual_environment_firewall_rules" "inbound" {
  depends_on = [
    proxmox_virtual_environment_vm.vm_tesla,
    proxmox_virtual_environment_cluster_firewall_security_group.ssh,
    proxmox_virtual_environment_cluster_firewall_security_group.monitoring,
    proxmox_virtual_environment_cluster_firewall_security_group.cockpit
  ]

  node_name = proxmox_virtual_environment_vm.vm_tesla.node_name
  vm_id     = proxmox_virtual_environment_vm.vm_tesla.vm_id

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.ssh.name
    comment        = "From security group, managed by OpenTofu. Allow SSH."
    iface          = "net0"
  }

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.monitoring.name
    comment        = "From security group, managed by OpenTofu. Allow MONITORING."
    iface          = "net0"
  }

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.cockpit.name
    comment        = "From security group, managed by OpenTofu. Allow COCKPIT."
    iface          = "net0"
  }
}
