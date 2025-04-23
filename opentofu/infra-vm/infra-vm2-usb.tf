# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_vm2usb" {
  length  = 24
  special = true
}

output "vm_root_password_vm2usb" {
  value     = random_password.vm_root_password_vm2usb.result
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_vm2usb" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pvename"

  source_raw {
    data      = <<-EOF
      instance-id: vm2usb-instance
      local-hostname: vm2usb
    EOF
    file_name = "vm2usb_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "onduleur" {
  comment = "UPS Eaton 3S"
  name    = "onduleur"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "pvename"
    },
  ]
}

resource "proxmox_virtual_environment_file" "user_cloud_config_vm2usb" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pvename"

  source_raw {
    data      = <<-EOF
      #cloud-config

      #### user-data file for an Arch Linux VM, update commands to your needs and your distribution ####

      hostname: vm2usb
      manage_etc_hosts: true

      allow_public_ssh_keys: true
      ssh_quiet_keygen: true

      users:
        - name: root
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 xxxx

        - name: useradmin
          groups: wheel
          lock_passwd: false
          passwd: $6$rounds=500000$tAy4OxDkBy61IO3n$qMZ5IBOoMUvXAgIB4PYkaZzZlalE4Ez0XOb9AYP1dCyK9WsxE4ySFLd2HacSdgaPLakcks5bGmDVo/r7O0H9r1
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 xxxx
          sudo: ALL=(ALL) NOPASSWD:ALL

      # Misc settings
      locale: en_US.UTF-8
      package_update: false # because we will update the system in the runcmd section (pacman instead of apt)
      package_upgrade: false
      timezone: Europe/Paris

      bootcmd:
        - pacman-key --init
        - pacman-key --populate archlinux
        - pacman -Sy --noconfirm archlinux-keyring reflector rsync
        - reflector --country France --protocol https --latest 5 --age 24 --sort rate --save /etc/pacman.d/mirrorlist
        - pacman -Sy --noconfirm gptfdisk

      runcmd:
        - rm -f /etc/machine-id
        - rm -f /var/lib/dbus/machine-id
        - ln -s /etc/machine-id /var/lib/dbus/machine-id
        - swapoff -a
        - sed -i 's|^/swap/swapfile|#/swap/swapfile|' /etc/fstab
        - systemctl daemon-reload
        - pacman -Syu --noconfirm bash-completion cloud-guest-utils extra/cockpit curl extra/cockpit-storaged less libiscsi nano extra/netdata pcp qemu-guest-agent udisks2-btrfs vim

        # DEBUT // Systemd configuration
        - sed -i 's/^#Cache=.*/Cache=yes/' /etc/systemd/resolved.conf
        - sed -i 's/^#Domains=/Domains=dc.garage.hommet.net/' /etc/systemd/resolved.conf
        - sed -i 's/^#DNS=/DNS=192.168.1.250/' /etc/systemd/resolved.conf
        - sed -i 's/^#DNSStubListener=/DNSStubListener=no/' /etc/systemd/resolved.conf
        - sed -i 's/^#ReadEtcHosts=/ReadEtcHosts=yes/' /etc/systemd/resolved.conf
        - sed -i 's/^#LLMNR=/LLMNR=no/' /etc/systemd/resolved.conf
        - systemctl reload systemd-resolved
        # FIN // Systemd configuration

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

        - rm /etc/motd.d/cockpit /etc/issue.d/cockpit.issue
        - systemctl enable --now --all cockpit.socket netdata.service
        - systemctl stop --all
        - reboot -f
    EOF
    file_name = "vm2usb_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "vm_vm2usb" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_vm2usb,
    proxmox_virtual_environment_file.user_cloud_config_vm2usb,
    random_password.vm_root_password_vm2usb
  ]

  lifecycle { ignore_changes = [] }

  boot_order          = ["scsi0"]
  bios                = "ovmf"
  description         = "vm2usb. Services installés : `cockpit`"
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.2+pve1"
  migrate             = true
  name                = "vm2usb"
  node_name           = "pvename"
  on_boot             = true
  reboot_after_update = false
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  stop_on_destroy     = true
  tablet_device       = false
  tags                = ["arch", "infra", "vm"]
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = 181

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
    datastore_id = "local"
    discard      = "on"
    file_id      = "local:iso/Arch-Linux-x86_64-cloudimg.img"
    iothread     = true
    interface    = "scsi0"
    replicate    = false
    size         = 24
  }

  efi_disk {
    datastore_id      = "local"
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = "local"

    dns {
      domain  = "home.arpa"
      servers = ["172.16.255.250"]
    }

    ip_config {
      ipv4 {
        address = "172.16.255.33/24"
        gateway = "172.16.255.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_vm2usb.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_vm2usb.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    mac_address  = "BC:24:11:FF:FF:11"
    rate_limit   = 0
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  startup {
    order      = 1
    up_delay   = 5
    down_delay = 60
  }

  tpm_state {
    datastore_id = "local"
    version      = "v2.0"
  }

  usb {
    mapping = "onduleur"
    usb3    = false
  }

  vga {
    type = "virtio"
  }
}

resource "proxmox_virtual_environment_firewall_options" "fw_vm2usb" {
  depends_on    = [proxmox_virtual_environment_vm.vm_vm2usb]
  dhcp          = false
  enabled       = true
  input_policy  = "ACCEPT"
  log_level_in  = "info"
  log_level_out = "err"
  macfilter     = false
  ndp           = true
  node_name     = "pvename"
  output_policy = "ACCEPT"
  radv          = false
  vm_id         = proxmox_virtual_environment_vm.vm_vm2usb.vm_id
}

resource "proxmox_virtual_environment_firewall_rules" "fw_vm2usb_inbound" {
  depends_on = [
    proxmox_virtual_environment_cluster_firewall_security_group.security_groups["cockpit"],
    proxmox_virtual_environment_cluster_firewall_security_group.security_groups["ssh"]
  ]

  node_name = "pvename"
  vm_id     = proxmox_virtual_environment_vm.vm_vm2usb.vm_id

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.security_groups["cockpit"].name
    comment        = proxmox_virtual_environment_cluster_firewall_security_group.security_groups["cockpit"].comment
    iface          = "net0"
  }

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.security_groups["ssh"].name
    comment        = proxmox_virtual_environment_cluster_firewall_security_group.security_groups["ssh"].comment
    iface          = "net0"
  }
}
