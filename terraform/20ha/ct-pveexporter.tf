resource "proxmox_virtual_environment_hagroup" "ha_infra" {
  group   = "ha_infra"
  comment = "Managed by Terraform. Group for HA, specially infra CT & VM"
  nodes = {
    node1 = null
    node2 = 2
    node3 = 1
  }

  restricted  = true
  no_failback = false
}
