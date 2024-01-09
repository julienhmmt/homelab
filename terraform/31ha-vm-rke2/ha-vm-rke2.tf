resource "proxmox_virtual_environment_hagroup" "ha_vm_rke2" {
  group   = "ha_vm_rke2"
  comment = "Managed by Terraform. Group for HA specially for RKE2 CT & VM"
  nodes = {
    node1 = null
    node2 = 2
    node3 = 1
  }

  restricted  = true
  no_failback = false
}

resource "proxmox_virtual_environment_haresource" "ha_vm_rke2_master" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_rke2
  ]
  comment     = "Managed by Terraform."
  group       = proxmox_virtual_environment_hagroup.ha_vm_rke2.group
  max_relocate = 1
  max_restart = 2
  resource_id = "vm:241010"
  state       = "started"
}

resource "proxmox_virtual_environment_haresource" "ha_vm_rke2_worker1" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_rke2
  ]
  comment     = "Managed by Terraform."
  group       = proxmox_virtual_environment_hagroup.ha_vm_rke2.group
  max_relocate = 1
  max_restart = 2
  resource_id = "vm:242010"
  state       = "started"
}

resource "proxmox_virtual_environment_haresource" "ha_vm_rke2_worker" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_rke2
  ]
  comment     = "Managed by Terraform."
  group       = proxmox_virtual_environment_hagroup.ha_vm_rke2.group
  max_relocate = 1
  max_restart = 2
  resource_id = "vm:243010"
  state       = "started"
}
