resource "proxmox_virtual_environment_pool" "operations_pool" {
  for_each = toset(var.pool_ids) # Convert the list to a set for unique values

  comment = "Managed by Terraform"
  pool_id = each.key
}
