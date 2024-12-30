resource "proxmox_virtual_environment_download_file" "pbs_122024" {
  checksum           = "affc6479fdf2ecb92e164cdf5f827281edb30d7ba27558201fcff5d620adfc42"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "proxmox-backup-server_3.3-1.iso"
  node_name          = "miniquarium"
  url                = "https://enterprise.proxmox.com/iso/proxmox-backup-server_3.3-1.iso"
}

resource "proxmox_virtual_environment_download_file" "archlinux_iso_122024" {
  checksum           = "56b246d1a569f1670c0f98198f5c9a32558d54d010cd3434356cc1e20ad97945"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "archlinux-2024.12.01-x86_64.iso"
  node_name          = "miniquarium"
  url                = "https://archlinux.mirrors.ovh.net/archlinux/iso/2024.12.01/archlinux-2024.12.01-x86_64.iso"
}

resource "proxmox_virtual_environment_download_file" "ubuntu22_iso_122024" {
  checksum           = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-22.04.5-live-server-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
}

resource "proxmox_virtual_environment_download_file" "ubuntu24_iso_112024" {
  checksum           = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-24.04.1-live-server-amd64.iso"
  node_name          = "miniquarium"
  url                = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
}

resource "proxmox_virtual_environment_download_file" "debian12_iso_112024" {
  checksum           = "04396d12b0f377958a070c38a923c227832fa3b3e18ddc013936ecf492e9fbb3"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "debian-12.8.0-amd64-netinst.iso"
  node_name          = "miniquarium"
  url                = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso"
}