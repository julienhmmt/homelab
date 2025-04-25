locals {
  talos = {
    version = "v1.9.5"
    schema  = "ca84112fe212adcded1df4faf04156b49a915b14926c43e19fc09b06be2d06ae"
  }
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = "pvename"
  file_name               = "talos-${local.talos.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${local.talos.schema}/${local.talos.version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
