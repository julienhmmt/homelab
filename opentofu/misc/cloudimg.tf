resource "proxmox_virtual_environment_download_file" "debian12_img" {
  content_type       = "iso"
  datastore_id       = "iso"
  file_name          = "debian-12-genericcloud-amd64-20240901-1857.qcow2.img"
  node_name          = "proxmox"
  url                = "https://cloud.debian.org/images/cloud/bookworm/20240901-1857/debian-12-genericcloud-amd64-20240901-1857.qcow2"
  checksum           = "a901963590db6847252f1f7e48bb99b5bc78c8e38282767433e24682a96ea83aa764a2c8c16ae388faee2ff4176dbf826e8592660cdbf4ebff7bd222b9606da8"
  checksum_algorithm = "sha512"
  upload_timeout     = 180
}

resource "proxmox_virtual_environment_download_file" "archlinux_img" {
  content_type       = "iso"
  datastore_id       = "iso"
  file_name          = "archlinux-genericcloud-amd64-v20240915.qcow2.img"
  node_name          = "proxmox"
  url                = "https://geo.mirror.pkgbuild.com/images/v20240915.263127/Arch-Linux-x86_64-cloudimg.qcow2"
  checksum           = "b2aee43d31e90bc1913fbc14fee93d3e6d834ff201bd237a5ccfd4e74cd56aa8"
  checksum_algorithm = "sha256"
  upload_timeout     = 180
}