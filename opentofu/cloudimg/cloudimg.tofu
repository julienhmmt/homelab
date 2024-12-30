resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg_latest" {
  checksum           = "98611f5466eee88d43322110da791f94f957ee4c42866e994f55dd5c220d4c7e"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "arch-linux-cloudimg-amd64-latest.qcow2.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
}

resource "proxmox_virtual_environment_download_file" "debian12_cloudimg_latest" {
  checksum           = "340cdafca262582e2ec013f2118a7daa9003436559a3e1cff637af0fc05d4c3755d43e15470bb40d7dd4430d355b44d098283fc4c7c6f640167667479eeeb0e0"
  checksum_algorithm = "sha512"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "debian-12-genericcloud-amd64-latest.qcow2.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_minimal_latest" {
  checksum           = "4b0020732971ecc1b0b4409285a11d3f992537dd14e8a677e06d3420d881eacd"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-22.04-server-cloudimg-minimal-latest-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_latest" {
  checksum           = "0d8345a343c2547e55ac815342e6cb4a593aa5556872651eb47e6856a2bb0cdd"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-22.04-server-cloudimg-latest-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_latest" {
  checksum           = "e61484705035cd64d8e79c35d6f674acccf03ef9c6939ca50dea8a4fdc7eabeb"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-24.04-server-cloudimg-latest-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_minimal_latest" {
  checksum           = "c4f9e677e3ff2f09c7f3bf17fef0ae76a9a6b3249b91d89e2b32c6f9ee1c97ed"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local-nvme-vm"
  file_name          = "ubuntu-24.04-server-cloudimg-minimal-latest-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
}