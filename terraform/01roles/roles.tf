data "proxmox_virtual_environment_role" "terraform_role" {
  role_id = "PVEAdmin"
}

output "terraform_role_privileges" {
  value     = data.proxmox_virtual_environment_role.terraform_role.privileges
  sensitive = true
}

# PROMBOT
resource "random_password" "prombot_password" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "prombot_password" {
  value     = random_password.prombot_password.result
  sensitive = true
}

resource "proxmox_virtual_environment_user" "prombot" {
  acl {
    path      = "/"
    propagate = true
    role_id   = "PVEAuditor"
  }

  comment = "Managed by Terraform. Used only for monitoring."
  enabled = true
  user_id = "prombot@pve"
}
