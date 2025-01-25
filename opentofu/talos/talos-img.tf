resource "proxmox_virtual_environment_download_file" "talos_img" {
  node_name    = "miniquarium"
  content_type = "iso"
  datastore_id = "local"
  file_name    = "talos-v1.9.2.qcow2.img"
  url          = "https://factory.talos.dev/image/89502df2dee302dd817cc88d7f0268e3cd2c1bb4eaa4e21445f35d0cf9324497/v1.9.2/metal-amd64.qcow2"
  overwrite    = false
}