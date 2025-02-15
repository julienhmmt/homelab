resource "proxmox_virtual_environment_vm" "data_vm_challenger" {
  node_name  = "miniquarium"
  on_boot    = false
  protection = true
  started    = false
  tags       = ["NE_PAS_SUPPRIMER"]
  vm_id      = 9991032

  disk {
    datastore_id = "local-nvme"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 128
  }
}