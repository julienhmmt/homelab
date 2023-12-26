module "pve" {
  source = "../modules"
}

resource "proxmox_virtual_environment_pool" "infra" {
  comment = "Managed by Terraform"
  pool_id = "infra"
}

resource "proxmox_virtual_environment_pool" "modeles" {
  comment = "Managed by Terraform"
  pool_id = "modeles"
}

resource "proxmox_virtual_environment_pool" "prod" {
  comment = "Managed by Terraform"
  pool_id = "production"
}

resource "proxmox_virtual_environment_pool" "preprod" {
  comment = "Managed by Terraform"
  pool_id = "pre-production"
}
