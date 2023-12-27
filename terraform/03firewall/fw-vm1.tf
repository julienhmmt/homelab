# resource "proxmox_virtual_environment_firewall_rules" "inbound" {
#   depends_on = [
#     proxmox_virtual_environment_vm.example,
#     proxmox_virtual_environment_cluster_firewall_security_group.example,
#   ]

#   node_name = proxmox_virtual_environment_vm.example.node_name
#   vm_id     = proxmox_virtual_environment_vm.example.vm_id

#   rule {
#     type    = "in"
#     action  = "ACCEPT"
#     comment = "Allow HTTP"
#     dest    = "192.168.1.5"
#     dport   = "80"
#     proto   = "tcp"
#     log     = "info"
#   }

#   rule {
#     type    = "in"
#     action  = "ACCEPT"
#     comment = "Allow HTTPS"
#     dest    = "192.168.1.5"
#     dport   = "443"
#     proto   = "tcp"
#     log     = "info"
#   }

#   rule {
#     security_group = proxmox_virtual_environment_cluster_firewall_security_group.example.name
#     comment        = "From security group"
#     iface          = "net0"
#   }
# }