output "vm_name" {
  description = "The name of the VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ip" {
  description = "The IP address of the VM"
  value       = var.vm_ipv4_address
}
