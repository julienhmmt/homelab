resource "proxmox_virtual_environment_download_file" "pbs_122024" { # Proxmox Backup Server 3.3-1 12/2024
  checksum           = "affc6479fdf2ecb92e164cdf5f827281edb30d7ba27558201fcff5d620adfc42"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "proxmox-backup-server_3.3-1.iso"
  node_name          = "miniquarium"
  url                = "https://enterprise.proxmox.com/iso/proxmox-backup-server_3.3-1.iso"
}

resource "proxmox_virtual_environment_download_file" "archlinux_iso" { # Arch Linux 2025.02.01
  checksum           = "45f097416d604ac20e982d2137534ffbe00990ba36dcb9bd259c05a4515f20cd"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "archlinux-2025.02.01-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://archlinux.mirrors.ovh.net/archlinux/iso/2025.02.01/archlinux-2025.02.01-x86_64.iso"
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

resource "proxmox_virtual_environment_download_file" "debian12_iso" { # Debian 12.9.0 01/2025
  checksum           = "1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "debian-12.9.0-amd64-netinst.iso"
  node_name          = "miniquarium"
  url                = "https://gemmei.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
}

resource "proxmox_virtual_environment_download_file" "nixos_gnome_iso" {
  checksum           = "14811b6e68b0580de01bdaf8f84baa24c710f31c3f6cca13a09b97b992646d0d"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "nixos-24.11-gnome-x86_64-linux.iso"
  node_name          = "miniquarium"
  url                = "https://channels.nixos.org/nixos-24.11/latest-nixos-gnome-x86_64-linux.iso"
}

resource "proxmox_virtual_environment_download_file" "nixos_minimal_iso" {
  checksum           = "05430318cf92a262ebba5902c9b488a22615758868018ec022873ab715b11b17"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "nixos-24.11-minimal-x86_64-linux.iso"
  node_name          = "miniquarium"
  url                = "https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso"
}

resource "proxmox_virtual_environment_download_file" "fedora41_iso" {
  checksum           = "a2dd3caf3224b8f3a640d9e31b1016d2a4e98a6d7cb435a1e2030235976d6da2"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "Fedora-Workstation-Live-x86_64-41-1.4.iso"
  node_name          = "miniquarium"
  url                = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-41-1.4.iso"
}

resource "proxmox_virtual_environment_download_file" "almalinux95_iso" {
  checksum           = "eef492206912252f2e24a74d3133b46cb4d240b54ffb3300a94000905b2590d3"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "AlmaLinux-9.5-x86_64-minimal.iso"
  node_name          = "miniquarium"
  url                = "https://repo.almalinux.org/almalinux/9.5/isos/x86_64/AlmaLinux-9.5-x86_64-minimal.iso"
}

resource "proxmox_virtual_environment_download_file" "almalinux95_qcow2" {
  checksum           = "abddf01589d46c841f718cec239392924a03b34c4fe84929af5d543c50e37e37"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.img"
  node_name          = "miniquarium"
  url                = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2"
}

output "archlinux_iso_file_id" { value = proxmox_virtual_environment_download_file.archlinux_iso.id }
output "debian12_iso_file_id" { value = proxmox_virtual_environment_download_file.debian12_iso.id }
output "pbs_122024_file_id" { value = proxmox_virtual_environment_download_file.pbs_122024.id }
output "ubuntu22_iso_file_id" { value = proxmox_virtual_environment_download_file.ubuntu22_iso.id }
output "ubuntu24_iso_file_id" { value = proxmox_virtual_environment_download_file.ubuntu24_iso.id }
output "nixos_gnome_iso_file_id" { value = proxmox_virtual_environment_download_file.nixos_gnome_iso.id }
output "nixos_minimal_iso_file_id" { value = proxmox_virtual_environment_download_file.nixos_minimal_iso.id }
output "fedora41_iso_file_id" { value = proxmox_virtual_environment_download_file.fedora41_iso.id }
output "almalinux95_iso_file_id" { value = proxmox_virtual_environment_download_file.almalinux95_iso.id }
output "almalinux95_qcow2_file_id" { value = proxmox_virtual_environment_download_file.almalinux95_qcow2.id }
