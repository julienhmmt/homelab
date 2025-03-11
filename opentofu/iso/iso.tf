resource "proxmox_virtual_environment_download_file" "almalinux8_iso" { # AlmaLinux 8.10 Minimal 05/2024
  checksum           = "e524329700abe47ce1f509bed7e2d3c68b336a54c712daa1b492b2429a64d419"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "AlmaLinux-8-x86_64-minimal.iso"
  node_name          = "miniquarium"
  url                = "https://repo.almalinux.org/almalinux/8/isos/x86_64/AlmaLinux-8-latest-x86_64-minimal.iso"
}

resource "proxmox_virtual_environment_download_file" "almalinux95_iso" { # AlmaLinux 9.5 Minimal 12/2024
  checksum           = "eef492206912252f2e24a74d3133b46cb4d240b54ffb3300a94000905b2590d3"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "AlmaLinux-9.5-x86_64-minimal.iso"
  node_name          = "miniquarium"
  url                = "https://repo.almalinux.org/almalinux/9.5/isos/x86_64/AlmaLinux-9.5-x86_64-minimal.iso"
}

resource "proxmox_virtual_environment_download_file" "alpine_standard_iso" { # Alpine Linux 3.21.2 Standard 02/2025
  checksum           = "706e9521cd21188786cb983131040ee68399e504924ea3318d600d1e04a93878"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "alpine-standard-3.21.2-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-standard-3.21.2-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "alpine_virt_iso" { # Alpine Linux 3.21.2 Virt 02/2025
  checksum           = "e877549fb113ba93f89f3755742f3e5178ae66fb345bf6a74a9ddbe1e8bd2ec6"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "alpine-virt-3.21.2-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-virt-3.21.2-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "archlinux_iso" { # Arch Linux 2025.03.01
  checksum           = "8150e3c1a479de9134baa13cea4ff78856cca5ebeb9bdfa87ecfce2e47ac9b5b"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "archlinux-2025.03.01-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://archlinux.mirrors.ovh.net/archlinux/iso/2025.03.01/archlinux-2025.03.01-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "debian12_iso" { # Debian 12.9.0 01/2025
  checksum           = "1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "debian-12.9.0-amd64-netinst.iso"
  node_name          = "miniquarium"
  url                = "https://gemmei.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
}

resource "proxmox_virtual_environment_download_file" "endeavouros_iso" { # EndeavourOS 2025.02.08
  checksum           = "5cdc71bb31f900f973182d4c1925f6512172acd1a5321d85467bdd58c5b3f1a59e36f08534493d1ff1e474843ff1ad1933c97014a63d8f74fb238566233c62a4"
  checksum_algorithm = "sha512"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "EndeavourOS_Mercury-2025.02.08.iso"
  node_name          = "miniquarium"
  url                = "https://mirror.rznet.fr/endeavouros/iso/EndeavourOS_Mercury-2025.02.08.iso"
}

resource "proxmox_virtual_environment_download_file" "fedora41_iso" { # Fedora 41 Workstation 02/2025
  checksum           = "a2dd3caf3224b8f3a640d9e31b1016d2a4e98a6d7cb435a1e2030235976d6da2"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "Fedora-Workstation-Live-x86_64-41-1.4.iso"
  node_name          = "miniquarium"
  url                = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-41-1.4.iso"
}

resource "proxmox_virtual_environment_download_file" "gparted_live_iso" { # GParted Live 1.7.0-1 02/2025
  checksum           = "f03fa7a9652c84c6e0d762a323a3474ca5e1887296aeb49c609c8bc2979f0de3"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "gparted-live-1.7.0-1-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://downloads.sourceforge.net/project/gparted/gparted-live-stable/1.7.0-1/gparted-live-1.7.0-1-amd64.iso?ts=gAAAAABnqQ83X_6l9iUuxFutCBNvZgg_5e__pi3o08suyTK8nYB7KBmkoum1wKStiHM4sysn5z0i-vdiPQrQSPeR3CtKl-WvJw%3D%3D&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgparted%2Ffiles%2Fgparted-live-stable%2F1.7.0-1%2Fgparted-live-1.7.0-1-amd64.iso%2Fdownload"
}

resource "proxmox_virtual_environment_download_file" "ipfire_iso" { # IPFire 2.29 Core 192
  # checksum           = ""
  # checksum_algorithm = "sha256"
  content_type = "iso"
  datastore_id = "local"
  file_name    = "ipfire-2.29-core192-x86_64.iso"
  node_name    = "miniquarium"
  url          = "https://downloads.ipfire.org/releases/ipfire-2.x/2.29-core192/ipfire-2.29-core192-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "kali_iso" { # Kali Linux 2024.4 12/2024
  checksum           = "f07c14ff6f5a89024b2d0d0427c3bc94de86b493a0598a2377286b87478da706"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "kali-linux-2024.4-live-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://cdimage.kali.org/kali-2024.4/kali-linux-2024.4-live-amd64.iso"
}

# resource "proxmox_virtual_environment_download_file" "nixos_gnome_iso" { # NixOS 24.11 GNOME 12/2024
#   checksum           = "14811b6e68b0580de01bdaf8f84baa24c710f31c3f6cca13a09b97b992646d0d"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "nixos-24.11-gnome-x86_64-linux.iso"
#   node_name          = "miniquarium"
#   url                = "https://channels.nixos.org/nixos-24.11/latest-nixos-gnome-x86_64-linux.iso"
# }

# resource "proxmox_virtual_environment_download_file" "nixos_minimal_iso" { # NixOS 24.11 Minimal 12/2024
#   checksum           = "05430318cf92a262ebba5902c9b488a22615758868018ec022873ab715b11b17"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "nixos-24.11-minimal-x86_64-linux.iso"
#   node_name          = "miniquarium"
#   url                = "https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso"
# }

resource "proxmox_virtual_environment_download_file" "opnsense_img" { # OPNsense 25.1 12/2024
  # checksum                = "89fcf5bdb1d2ea2ea6ba4cdc1268ea0a1e22b944330d7bee0711c8630cc905af"
  # checksum_algorithm      = "sha256"
  content_type            = "iso"
  datastore_id            = "local"
  file_name               = "OPNsense-25.1-vga-amd64.img"
  node_name               = "miniquarium"
  url                     = "https://pkg.opnsense.org/releases/25.1/OPNsense-25.1-vga-amd64.img.bz2"
  decompression_algorithm = "bz2"
  overwrite_unmanaged     = false
}

resource "proxmox_virtual_environment_download_file" "pbs_122024" { # Proxmox Backup Server 3.3-1 12/2024
  checksum           = "affc6479fdf2ecb92e164cdf5f827281edb30d7ba27558201fcff5d620adfc42"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "proxmox-backup-server_3.3-1.iso"
  node_name          = "miniquarium"
  url                = "https://enterprise.proxmox.com/iso/proxmox-backup-server_3.3-1.iso"
}

resource "proxmox_virtual_environment_download_file" "qubes_iso" { # Qubes OS 4.2.3 01/2025
  checksum           = "46a0dce03b72d8c222dc28c8bd164f4f37bc9c6ce2d66a266c9a064733ba2690"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "Qubes-R4.2.3-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://mirrors.edge.kernel.org/qubes/iso/Qubes-R4.2.3-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "tails_iso" { # Tails 6.12 01/2025
  content_type = "iso"
  datastore_id = "local"
  file_name    = "tails-amd64-6.13.iso"
  node_name    = "miniquarium"
  url          = "https://download.tails.net/tails/stable/tails-amd64-6.13/tails-amd64-6.13.iso"
}

resource "proxmox_virtual_environment_download_file" "truenas_scale_iso" { # TrueNAS SCALE 24.10.2 02/2025
  checksum           = "33e29ed62517bc5d4aed6c80b9134369e201bb143e13fefdec5dbf3820f4b946"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "TrueNAS-SCALE-24.10.2.iso"
  node_name          = "miniquarium"
  url                = "https://download.sys.truenas.net/TrueNAS-SCALE-ElectricEel/24.10.2/TrueNAS-SCALE-24.10.2.iso"
}

resource "proxmox_virtual_environment_download_file" "ubuntu22_iso" { # Ubuntu 22.04.5 LTS 12/2024
  checksum           = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-22.04.5-live-server-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
}

resource "proxmox_virtual_environment_download_file" "ubuntu24_iso" { # Ubuntu 24.04.1 LTS 12/2024
  checksum           = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-24.04.1-live-server-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
}

output "almalinux8_iso_file_id" { value = proxmox_virtual_environment_download_file.almalinux8_iso.id }
output "almalinux95_iso_file_id" { value = proxmox_virtual_environment_download_file.almalinux95_iso.id }
output "alpine_standard_iso_file_id" { value = proxmox_virtual_environment_download_file.alpine_standard_iso.id }
output "alpine_virt_iso_file_id" { value = proxmox_virtual_environment_download_file.alpine_virt_iso.id }
output "archlinux_iso_file_id" { value = proxmox_virtual_environment_download_file.archlinux_iso.id }
output "debian12_iso_file_id" { value = proxmox_virtual_environment_download_file.debian12_iso.id }
output "endeavouros_iso_file_id" { value = proxmox_virtual_environment_download_file.endeavouros_iso.id }
output "fedora41_iso_file_id" { value = proxmox_virtual_environment_download_file.fedora41_iso.id }
output "gparted_live_iso_file_id" { value = proxmox_virtual_environment_download_file.gparted_live_iso.id }
output "ipfire_iso_file_id" { value = proxmox_virtual_environment_download_file.ipfire_iso.id }
output "kali_iso_file_id" { value = proxmox_virtual_environment_download_file.kali_iso.id }
# output "nixos_gnome_iso_file_id" { value = proxmox_virtual_environment_download_file.nixos_gnome_iso.id }
# output "nixos_minimal_iso_file_id" { value = proxmox_virtual_environment_download_file.nixos_minimal_iso.id }
output "opnsense_img_file_id" { value = proxmox_virtual_environment_download_file.opnsense_img.id }
output "pbs_122024_file_id" { value = proxmox_virtual_environment_download_file.pbs_122024.id }
output "qubes_iso_file_id" { value = proxmox_virtual_environment_download_file.qubes_iso.id }
output "tails_iso_file_id" { value = proxmox_virtual_environment_download_file.tails_iso.id }
output "truenas_scale_iso_file_id" { value = proxmox_virtual_environment_download_file.truenas_scale_iso.id }
output "ubuntu22_iso_file_id" { value = proxmox_virtual_environment_download_file.ubuntu22_iso.id }
output "ubuntu24_iso_file_id" { value = proxmox_virtual_environment_download_file.ubuntu24_iso.id }
