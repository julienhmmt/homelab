// HA configuration

resource "proxmox_virtual_environment_hagroup" "ha_vm_k3s" {
  group   = "ha_vm_k3s"
  comment = "Managed by Terraform. Group for HA specially for k3s VM"
  nodes = {
    node1 = null
    node2 = 2
    node3 = 1
  }

  restricted  = true
  no_failback = false
}

resource "proxmox_virtual_environment_haresource" "ha_vm_k3s_master1" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_k3s
  ]
  comment      = "Managed by Terraform."
  group        = proxmox_virtual_environment_hagroup.ha_vm_k3s.group
  max_relocate = 1
  max_restart  = 2
  resource_id  = "vm:241010"
  state        = "started"
}

resource "proxmox_virtual_environment_haresource" "ha_vm_k3s_master2" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_k3s
  ]
  comment      = "Managed by Terraform."
  group        = proxmox_virtual_environment_hagroup.ha_vm_k3s.group
  max_relocate = 1
  max_restart  = 2
  resource_id  = "vm:242010"
  state        = "started"
}

resource "proxmox_virtual_environment_haresource" "ha_vm_k3s_master3" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_vm_k3s
  ]
  comment      = "Managed by Terraform."
  group        = proxmox_virtual_environment_hagroup.ha_vm_k3s.group
  max_relocate = 1
  max_restart  = 2
  resource_id  = "vm:243010"
  state        = "started"
}
