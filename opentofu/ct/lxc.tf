# # see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
# resource "random_password" "ct_root_password" {
#   for_each         = var.ct
#   length           = 24
#   override_special = "_%@"
#   special          = true
# }

# output "ct_root_password" {
#   value     = { for key, pwd in random_password.ct_root_password : key => pwd.result }
#   sensitive = true
# }

# # location of containers templates
# resource "proxmox_virtual_environment_file" "debian_container_template" {
#   content_type = "vztmpl"
#   datastore_id = "local"
#   node_name    = "pve1"

#   source_file {
#     path = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
#   }
# }

# resource "proxmox_virtual_environment_container" "ct" {
#   depends_on = [
#     proxmox_virtual_environment_file.debian_container_template,
#     proxmox_virtual_environment_file.hook_script,
#     random_password.ct_root_password
#   ]
#   for_each = var.ct

#   description         = each.value.description
#   hook_script_file_id = each.value.hook_script_file_id
#   node_name           = "pve1"
#   pool_id             = each.value.pool_id
#   start_on_boot       = each.value.start_on_boot
#   tags                = each.value.tags
#   unprivileged        = each.value.unprivileged
#   vm_id               = each.value.id

#   cpu {
#     architecture = "amd64"
#     cores        = each.value.cpu_cores
#   }

#   disk {
#     datastore_id = "local-zfs"
#     size         = each.value.disk_size
#   }

#   features {
#     nesting = true
#     fuse    = false
#   }

#   initialization {
#     hostname = each.value.hostname

#     dns {
#       domain  = each.value.domain
#       servers = ["192.168.1.2"]
#     }

#     ip_config {
#       ipv4 {
#         address = each.value.ipv4
#         gateway = "192.168.1.254"
#       }
#     }
#     user_account {
#       keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
#       password = random_password.ct_root_password[each.key].result
#     }
#   }

#   memory {
#     dedicated = each.value.ram
#     swap      = each.value.swap
#   }

#   network_interface {
#     name        = "vmbr0"
#     mac_address = each.value.net_mac_address
#     rate_limit  = each.value.net_rate_limit
#   }

#   operating_system {
#     template_file_id = proxmox_virtual_environment_file.debian_container_template.id
#     type             = "debian"
#   }

#   startup {
#     order    = each.value.startup_order
#     up_delay = each.value.startup_up_delay
#   }

#   timeout_create = 120
#   timeout_delete = 120
#   timeout_update = 60
# }

# resource "proxmox_virtual_environment_file" "hook_script" {
#   for_each = var.hook_scripts

#   content_type = "snippets"
#   datastore_id = "local"
#   file_mode = "0700"
#   node_name    = "pve1"

#   source_raw {
#     data      = each.value
#     file_name = each.key
#   }
# }
