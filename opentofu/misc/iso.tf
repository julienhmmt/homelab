resource "proxmox_virtual_environment_download_file" "pbs_042024" {
  content_type       = "iso"
  datastore_id       = "iso"
  file_name          = "proxmox-backup-server_3.2-1.iso"
  node_name          = "proxmox"
  url                = "https://enterprise.proxmox.com/iso/proxmox-backup-server_3.2-1.iso"
  checksum           = "1d19698e8f7e769cf0a0dcc7ba0018ef5416c5ec495d5e61313f9c84a4237607"
  checksum_algorithm = "sha256"
}