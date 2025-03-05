# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "vm_root_password_charger" {
  length  = 24
  special = true
}

output "vm_root_password_charger" {
  value     = random_password.vm_root_password_charger.result
  sensitive = true
}

resource "proxmox_virtual_environment_file" "meta_cloud_config_charger" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      instance-id: charger-instance
      local-hostname: charger
    EOF
    file_name = "charger_ci_meta-data.yml"
  }
}

resource "proxmox_virtual_environment_file" "user_cloud_config_charger" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "miniquarium"

  source_raw {
    data      = <<-EOF
      #cloud-config

      hostname: charger
      manage_etc_hosts: true

      allow_public_ssh_keys: true
      ssh_quiet_keygen: true

      users:
        - name: root
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10

        - name: jhoadmin
          lock_passwd: false
          sudo: ALL=(ALL) NOPASSWD:ALL
          groups: wheel
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10
          passwd: $6$rounds=500000$tAy4OxDkBy61IO3n$qMZ5IBOoMUvXAgIB4PYkaZzZlalE4Ez0XOb9AYP1dCyK9WsxE4ySFLd2HacSdgaPLakcks5bGmDVo/r7O0H9r1

      # Misc settings
      locale: en_US.UTF-8
      package_update: false # because we will update the system in the runcmd section (pacman instead of apt)
      package_upgrade: false
      timezone: Europe/Paris

      bootcmd:
        - pacman-key --init
        - pacman-key --populate archlinux
        - pacman -Sy --noconfirm archlinux-keyring reflector rsync xfsprogs
        - reflector --country France --latest 5 --age 24 --sort rate --save /etc/pacman.d/mirrorlist
        - pacman -Sy --noconfirm gptfdisk

      # Disk setup
      disk_setup:
        /dev/sdb:
          table_type: gpt
          layout: true
          overwrite: true
        /dev/sdc:
          table_type: gpt
          layout: true
          overwrite: true
      fs_setup:
        - label: nfs_data
          filesystem: xfs
          device: /dev/sdb1
          overwrite: true
        - label: s3_data
          filesystem: btrfs
          device: /dev/sdc1
          overwrite: true

      write_files:
        - path: /etc/systemd/system/srv-nfs.mount
          content: |
            [Unit]
            Description=Mount /srv/nfs
            After=network.target

            [Mount]
            What=/dev/sdb1
            Where=/srv/nfs
            Type=xfs
            Options=defaults

            [Install]
            WantedBy=multi-user.target

        - path: /etc/systemd/system/srv-minio.mount
          content: |
            [Unit]
            Description=Mount /srv/minio
            After=network.target

            [Mount]
            What=/dev/sdc1
            Where=/srv/minio
            Type=xfs
            Options=defaults

            [Install]
            WantedBy=multi-user.target

      runcmd:
        - rm -f /etc/machine-id
        - rm -f /var/lib/dbus/machine-id
        - ln -s /etc/machine-id /var/lib/dbus/machine-id
        - swapoff -a
        - sed -i 's|^/swap/swapfile|#/swap/swapfile|' /etc/fstab
        - pacman -Syu --noconfirm bash-completion cloud-guest-utils extra/cockpit curl extra/cockpit-storaged less libiscsi libusb nano extra/netdata pcp qemu-guest-agent udisks2-btrfs vim

        # DEBUT // Installation et configuration MINIO
        - systemctl enable --now srv-minio.mount
        - pacman -S --noconfirm minio
        - mkdir -p /srv/minio/data
        - chown -R minio:minio /srv/minio
        - chmod -R 750 /srv/minio
        - sed -i 's|^# MINIO_ROOT_USER=example-user|MINIO_ROOT_USER=jhominioadmin|' /etc/minio/minio.conf
        - sed -i 's|^# MINIO_ROOT_PASSWORD=example-password|MINIO_ROOT_PASSWORD=Maturely8-Headboard4-Proofing7-Reptilian9-Maximize5|' /etc/minio/minio.conf
        - sed -i 's|^# MINIO_OPTS="--address :9199"|MINIO_OPTS="--address 192.168.1.32:9199 --console-address 192.168.1.32:19199"|' /etc/minio/minio.conf
        - systemctl enable --now minio.service

        # DEBUT // Installation et configuration NFS server
        - systemctl enable --now mnt-nfs.mount
        - pacman -S --noconfirm nfs-utils
        - mkdir -p /srv/nfs/gitea
        - mkdir -p /srv/nfs/vault
        - mkdir -p /srv/nfs/kubernetes
        - chmod -R 750 /srv/nfs
        - chown -R nobody:nobody /srv/nfs
        - chown -R root:root /srv/nfs/kubernetes
        - echo "/srv/nfs/gitea 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
        - echo "/srv/nfs/vault 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
        - echo "/srv/nfs/kubernetes 192.168.1.21/24(rw,sync,no_subtree_check,no_root_squash) 192.168.1.22/24(rw,sync,no_subtree_check,no_root_squash) 192.168.1.23/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
        - exportfs -arv
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
        - systemctl enable --now --all cockpit.socket netdata.service nut-driver-enumerator.service nfs-server.service
        - pacman -Rns --noconfirm cups
        - systemctl stop --all
        - reboot -f
    EOF
    file_name = "charger_ci_user-data.yml"
  }
}

resource "proxmox_virtual_environment_vm" "data_vm_charger" {
  node_name  = "miniquarium"
  on_boot    = false
  protection = true
  started    = false
  tags       = sort(["infra", "ne_pas_demarrer", "ne_pas_supprimer"])
  vm_id      = 9132

  disk { # NFS data disk
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 64
  }

  disk { # Minio S3 data disk
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi1"
    size         = 64
  }
}

resource "proxmox_virtual_environment_vm" "vm_charger" {
  depends_on = [
    proxmox_virtual_environment_file.meta_cloud_config_charger,
    proxmox_virtual_environment_file.user_cloud_config_charger,
    proxmox_virtual_environment_vm.data_vm_charger,
    random_password.vm_root_password_charger
  ]

  lifecycle { ignore_changes = [] }

  boot_order          = ["scsi0"]
  bios                = "ovmf"
  description         = "Tesla VM. Services installés : `cockpit`, `nfs-server`."
  keyboard_layout     = "fr"
  machine             = "pc-q35-9.0"
  migrate             = true
  name                = "charger"
  node_name           = "miniquarium"
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
  vm_id               = 132

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

  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm_charger.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      discard      = "on"
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      interface         = "scsi${data_disk.key + 1}"
    }
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
        address = "192.168.1.32/24"
        gateway = "192.168.1.254"
      }
    }

    meta_data_file_id = proxmox_virtual_environment_file.meta_cloud_config_charger.id
    user_data_file_id = proxmox_virtual_environment_file.user_cloud_config_charger.id
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    firewall     = true
    mac_address  = "BC:24:11:CA:FE:32"
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
    datastore_id = "local-nvme"
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
