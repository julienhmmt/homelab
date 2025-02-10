resource "proxmox_virtual_environment_download_file" "almalinux95_qcow2" { # AlmaLinux 9.5 GenericCloud 12/2024
  checksum           = "abddf01589d46c841f718cec239392924a03b34c4fe84929af5d543c50e37e37"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.img"
  node_name          = "miniquarium"
  url                = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "archlinux_cloudimg" { # Arch Linux 02/2025
  checksum           = "05af480ff2850e66b6a39b005c80464e045f2330b27a2350b1fbafc9c34f92b3"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "Arch-Linux-x86_64-cloudimg.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://geo.mirror.pkgbuild.com/images/v20250201.304316/Arch-Linux-x86_64-cloudimg.qcow2"
}

resource "proxmox_virtual_environment_download_file" "debian12_cloudimg" { # Debian 12 GenericCloud 02/2025
  checksum           = "a58d86525d75fd8e139a2302531ce5d2ab75ef0273cfe78f9d53aada4b23efd45f8433b4806fa4570cfe981c8fae26f5e5e855cbd66ba2198862f28125fd2d45"
  checksum_algorithm = "sha512"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "debian-12-genericcloud-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "ubuntu22_cloudimg" { # Ubuntu 22 Jammy 02/2025
  checksum           = "f5e78b40674136a57fc6e088c7f3f81d96ff2e6223039e4a15f5fec9c188e720"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-22-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/jammy/20250207/jammy-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "ubuntu24_cloudimg" { # Ubuntu 24 Noble 01/2025
  checksum           = "482244b83f49a97ee61fb9b8520d6e8b9c2e3c28648de461ba7e17681ddbd1c9"
  checksum_algorithm = "sha256"
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "ubuntu-24-amd64.img"
  node_name          = "miniquarium"
  upload_timeout     = 180
  url                = "https://cloud-images.ubuntu.com/noble/20250122/noble-server-cloudimg-amd64.img"
}

output "almalinux95_qcow2_file_id" { value = proxmox_virtual_environment_download_file.almalinux95_qcow2.id }
output "archlinux_cloudimg_file_id" { value = proxmox_virtual_environment_download_file.archlinux_cloudimg.id }
output "debian12_cloudimg_file_id" { value = proxmox_virtual_environment_download_file.debian12_cloudimg.id }
output "ubuntu22_cloudimg_file_id" { value = proxmox_virtual_environment_download_file.ubuntu22_cloudimg.id }
output "ubuntu24_cloudimg_file_id" { value = proxmox_virtual_environment_download_file.ubuntu24_cloudimg.id }
