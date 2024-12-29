resource "proxmox_virtual_environment_user" "proxmate_user" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.proxmate_role.role_id
  }
  comment  = "Managed by OpenTofu. Used only by the application Proxmate for iOS."
  enabled  = true
  password = data.sops_file.pve_secrets.data["proxmate_password"]
  user_id  = "proxmate@pve"
}

resource "proxmox_virtual_environment_role" "proxmate_role" {
  role_id = "ProxmateUser"
  privileges = [
    "Datastore.Allocate", "Datastore.AllocateSpace", "Datastore.AllocateTemplate", "Datastore.Audit", "Group.Allocate", "Permissions.Modify", "Pool.Audit", "SDN.Allocate", "SDN.Audit", "Sys.Audit", "User.Modify", "VM.Audit", "VM.PowerMgmt", "Sys.Console",
  ]
}