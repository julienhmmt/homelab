# resource "proxmox_virtual_environment_hagroup" "ha_ct_infra" {
#   group   = "ct_infra"
#   comment = "Managed by OpenTofu. Containers in this group are and needs to be always up."

#   nodes = {
#     pve1 = 1
#   }

#   restricted  = true
#   no_failback = false
# }

# resource "proxmox_virtual_environment_haresource" "ha_ct_infra_id" {
#   depends_on = [
#     proxmox_virtual_environment_hagroup.ha_ct_infra,
#     proxmox_virtual_environment_container.ct
#   ]

#   comment     = "Managed by Terraform"
#   for_each    = var.ct
#   group       = proxmox_virtual_environment_hagroup.ha_ct_infra.group
#   max_restart = 2
#   resource_id = "ct:${each.value.id}"
#   state       = "started"
# }
