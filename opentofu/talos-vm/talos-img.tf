# resource "proxmox_virtual_environment_download_file" "talos_img" {

#   node_name    = "miniquarium"
#   content_type = "iso"
#   datastore_id = "local-nvme-vm"

#   file_name               = "talos-v1.9.1.img"
#   url = "https://factory.talos.dev/image/698322b7ce860b1f034de6bc66315576c3b957ceff0934c8120891753f68de82/v1.9.1/metal-amd64.raw.zst"
#   decompression_algorithm = "gz"
#   overwrite               = false
# }