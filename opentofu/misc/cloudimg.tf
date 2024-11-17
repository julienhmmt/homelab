# resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg_latest" {
#   checksum           = "7751dda44d5e5daa2d6b6a73957b0b9a4e41cbde6d6cb29fcff672b5d54133e2"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "arch-linux-cloudimg-amd64-20241115.qcow2.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://geo.mirror.pkgbuild.com/images/v20241115.279641/Arch-Linux-x86_64-cloudimg-20241115.279641.qcow2"
# }

# resource "proxmox_virtual_environment_download_file" "debian12_cloudimg_latest" {
#   checksum           = "c939658113d6cd16398843078a942557048111db99442156498b2c5185461366ad7e52ac415b3f00b348cd81cf07333e6793faa0752fd3fbc725e39232f8e93a"
#   checksum_algorithm = "sha512"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "debian-12-genericcloud-amd64-20241110-1927.qcow2.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://cloud.debian.org/images/cloud/bookworm/20241110-1927/debian-12-genericcloud-amd64-20241110-1927.qcow2"
# }

# resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_minimal_latest" {
#   checksum           = "a426bbf3c64132d022792cafbf50d965b0fd8d68dd33b45eb96e327e8abb857c"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "ubuntu-22.04-server-cloudimg-minimal-amd64.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://cloud-images.ubuntu.com/minimal/releases/jammy/release-20241111/ubuntu-22.04-minimal-cloudimg-amd64.img"
# }

# resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg_latest" {
#   checksum           = "0ba0fd632a90d981625d842abf18453d5bf3fd7bb64e6dd61809794c6749e18b"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "ubuntu-22.04-server-cloudimg-amd64.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://cloud-images.ubuntu.com/jammy/20241004/jammy-server-cloudimg-amd64.img"
# }

# resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_latest" {
#   checksum           = "5dc7f9c796442a51316d8431480fbe3f62cadbfde4d58a14d34dd987c01fd655"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "ubuntu-24.04-server-cloudimg-amd64.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://cloud-images.ubuntu.com/noble/20241106/noble-server-cloudimg-amd64.img"
# }

# resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg_minimal_latest" {
#   checksum           = "d4ff5b1a8ab829a5ffc8580e16a047d7a7fc73455d528d7e76f20ffcfb51f7d3"
#   checksum_algorithm = "sha256"
#   content_type       = "iso"
#   datastore_id       = "local"
#   file_name          = "ubuntu-24.04-server-cloudimg-minimal-amd64.img"
#   node_name          = "proxmox"
#   upload_timeout     = 180
#   url                = "https://cloud-images.ubuntu.com/minimal/releases/noble/release-20241021/ubuntu-24.04-minimal-cloudimg-amd64.img"
# }