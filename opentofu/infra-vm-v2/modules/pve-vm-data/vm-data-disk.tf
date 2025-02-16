resource "proxmox_virtual_environment_vm" "data_vm" {
  description = var.vm_description
  node_name   = var.node_name
  on_boot     = false
  protection  = true
  started     = false
  tags        = var.vm_tags
  vm_id       = var.vm_id

  cpu {
    cores   = var.vm_cpu_cores_number
    sockets = 1
    type    = var.vm_cpu_type
  }

  memory {
    dedicated = 16
  }

  disk {
    datastore_id = var.vm_datastore_id
    file_format  = "raw"
    interface    = "scsi0"
    size         = var.vm_disk_size
  }
}