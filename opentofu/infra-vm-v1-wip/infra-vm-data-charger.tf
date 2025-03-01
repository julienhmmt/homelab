resource "proxmox_virtual_environment_vm" "data_vm" {
  for_each = var.vm_data

  node_name  = "miniquarium"
  on_boot    = false
  protection = true
  started    = false
  vm_id      = each.value.vm_id

  disk {
    datastore_id = each.value.disk_vm_datastore
    file_format  = "raw"
    interface    = "scsi0"
    size         = each.value.disk_size
  }
}
