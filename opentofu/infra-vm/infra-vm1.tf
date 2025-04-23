# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_vm1" {
  length  = 24
  special = true
}

output "vm_root_password_vm1" {
  value     = random_password.vm_root_password_vm1.result
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_vm1" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pvename"

  source_raw {
    data      = <<-EOF
      instance-id: vm1-instance
      local-hostname: vm1
    EOF
    file_name = "vm1_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config_vm1" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pvename"

  source_raw {
    data      = <<-EOF
      #cloud-config

      #### user-data file for an Arch Linux VM, update commands to your needs and your distribution ####

      hostname: vm1
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
        - pacman -Sy --noconfirm archlinux-keyring reflector rsync xfsprogs
        - reflector --country France --protocol https --latest 5 --age 24 --sort rate --save /etc/pacman.d/mirrorlist
        - pacman -Sy --noconfirm gptfdisk

      # Disk setup
      disk_setup:
        /dev/sdb:
          table_type: gpt
          layout: true
          overwrite: true
      fs_setup:
        - label: nfs_data
          filesystem: xfs
          device: /dev/sdb1
          overwrite: true

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

        # DEBUT // Installation et configuration NFS server
        - systemctl enable --now mnt-nfs.mount
        - mkdir -p /mnt/nfs/app1
        - chmod -R 755 /mnt/nfs
        - pacman -S --noconfirm nfs-utils
        - chown -R nobody:nobody /mnt/nfs
        - echo "/mnt/nfs/app1 172.16.255.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
        - exportfs -arv
        - systemctl restart nfs-server.service
        # FIN // Installation et configuration NFS server

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
        - systemctl enable --now --all cockpit.socket netdata.service nfs-server.service
        - systemctl stop --all
        - reboot -f

      write_files:
        - path: /etc/systemd/system/mnt-nfs.mount
          content: |
            [Unit]
            Description=Mount /mnt/nfs
            After=network.target

            [Mount]
            What=/dev/sdb1
            Where=/mnt/nfs
            Type=xfs
            Options=defaults

            [Install]
            WantedBy=multi-user.target
    EOF
    file_name = "vm1_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "data_vm_vm1" {
  node_name  = "pvename"
  on_boot    = false
  protection = true
  started    = false
  tags       = sort(["infra", "ne_pas_demarrer", "ne_pas_supprimer"])
  vm_id      = 999180

  disk { # NFS data disk
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 64
  }
}

resource "proxmox_virtual_environment_vm" "vm_vm1" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_vm1,
    proxmox_virtual_environment_file.user_cloud_config_vm1,
    proxmox_virtual_environment_vm.data_vm_vm1,
    random_password.vm_root_password_vm1
  ]

  lifecycle { ignore_changes = [] }

  boot_order          = ["scsi0"]
  bios                = "ovmf"
  description         = "VM1. Services installés : `cockpit`, `nfs-server`."
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.2+pve1"
  migrate             = true
  name                = "vm1"
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
  vm_id               = 180

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

  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm_vm1.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      discard           = "on"
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      interface         = "scsi${data_disk.key + 1}"
    }
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
        address = "172.16.255.32/24"
        gateway = "172.16.255.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_vm1.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_vm1.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    mac_address  = "BC:24:11:FF:FF:10"
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

  vga {
    type = "virtio"
  }
}

resource "proxmox_virtual_environment_firewall_options" "fw_vm1" {
  depends_on    = [proxmox_virtual_environment_vm.vm_vm1]
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
  vm_id         = proxmox_virtual_environment_vm.vm_vm1.vm_id
}

resource "proxmox_virtual_environment_firewall_rules" "fw_vm1_inbound" {
  depends_on = [
    proxmox_virtual_environment_cluster_firewall_security_group.security_groups["cockpit"],
    proxmox_virtual_environment_cluster_firewall_security_group.security_groups["ssh"]
  ]

  node_name = "pvename"
  vm_id     = proxmox_virtual_environment_vm.vm_vm1.vm_id

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
