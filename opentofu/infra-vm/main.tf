terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_host_address
  api_token = var.pve_api_token
  insecure  = true
  ssh {
    agent    = true
    username = var.cloudinit_user_account
  }
  tmp_dir = var.tmp_dir
}

module "vm1" {
  source = "../modules/vm"

    cloudinit_dns_domain   = "dc.local.hommet.net"
    cloudinit_dns_servers  = ["1.1.1.1", "9.9.9.9"]
    cloudinit_ssh_keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
    cloudinit_user_account = "jho"
    node_name              = "pve"
    pve_api_token          = "terrabot@pve!token_name=token_secret"
    pve_host_address       = "https://pve:8006"
    tags                   = ["linux", "opentofu"]
    tmp_dir                = "/tmp"
    vm_bridge_lan          = "vmbr0"
    vm_cpu_cores_number    = 1
    vm_cpu_type            = "x86-64-v2-AES"
    vm_datastore_id        = "local"
    vm_description         = "`tesla`. Managed by OpenTofu. Used for `nut`package, UPS monitoring."
    vm_disk_size           = 48
    vm_gateway_ipv4        = "192.168.1.254"
    vm_id                  = 10001
    vm_ipv4_address        = "192.168.1.31"
    vm_memory_max          = 2048
    vm_memory_min          = 2048
    vm_name                = "tesla"
    vm_socket_number       = 1
    vm_startup_order       = 1
}

# module "vm2" {
#   source = "./proxmox-vm-module"

#   vm_name                = "vm2"
#   vm_id                  = 1002
#   vm_description         = "VM2 Managed by Terraform"
#   vm_memory_max          = 8192
#   vm_memory_min          = 4096
#   vm_cpu_cores_number    = 2
#   vm_cpu_type            = "x86-64-v2-AES"
#   vm_disk_size           = 64
#   vm_bridge_lan          = "vmbr0"
#   vm_ipv4_address        = "172.16.241.12"
#   vm_gateway_ipv4        = "172.16.0.254"
#   cloudinit_dns_domain   = "your.domain.net"
#   cloudinit_dns_servers  = ["9.9.9.9"]
#   cloudinit_ssh_keys     = ["ssh-ed25519 changeme"]
#   cloudinit_user_account = "jho"
#   vm_datastore_id        = "local"
#   node_name              = "pve"
#   pve_api_token          = "terrabot@pve!token_name=token_secret"
#   pve_host_address       = "https://pve:8006"
#   tags                   = ["linux", "opentofu"]
#   tmp_dir                = "/tmp"
#   vm_startup_order       = "2"
#   vm_socket_number       = 1
# }
