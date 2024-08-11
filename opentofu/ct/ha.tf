resource "proxmox_virtual_environment_hagroup" "ha_ct" {
  group   = "ct"
  comment = "Managed by OpenTofu. Containers in this group are and needs to be always up."

  nodes = {
    pve1 = 1
  }

  restricted  = true
  no_failback = false
}

resource "proxmox_virtual_environment_haresource" "ha_ct_id" {
  depends_on = [
    proxmox_virtual_environment_hagroup.ha_ct
  ]

  for_each    = var.ct
  resource_id = "ct:${each.value.id}"
  state       = "started"
  group       = proxmox_virtual_environment_hagroup.ha_ct.group
  comment     = "Managed by Terraform"
}
