terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.71"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }
  }
}

provider "sops" {}

data "sops_file" "pve_secrets" {
  source_file = "pve_secrets.yaml"
}

provider "proxmox" {
  api_token = data.sops_file.pve_secrets.data["pve_api_token"]
  endpoint  = data.sops_file.pve_secrets.data["pve_endpoint"]
  insecure  = true # because self-signed TLS certificate is in use
  tmp_dir   = "/var/tmp/"

  ssh {
    agent    = true
    username = "root"
  }
}

### VMs comportant les données statiques
module "data_vm_charger" {
  source          = "./modules/pve-vm-data"

  node_name       = "miniquarium"
  vm_datastore_id = "local-nvme"
  vm_description  = "Managed by OpenTofu"
  vm_disk_size    = 128
  vm_id           = 99991031
  vm_name         = "data_charger"
  vm_tags         = ["NE_PAS_SUPPRIMER", "stateful"]
}

module "data_vm_ram" { # TALOS Worker
  source          = "./modules/pve-vm-data"

  node_name       = "miniquarium"
  vm_datastore_id = "local-nvme"
  vm_description  = "Managed by OpenTofu"
  vm_disk_size    = 128
  vm_id           = 99991022
  vm_name         = "data_ram"
  vm_tags         = ["NE_PAS_SUPPRIMER", "stateful", "talos"]
}

module "data_vm_viper" { # TALOS Worker
  source          = "./modules/pve-vm-data"

  node_name       = "miniquarium"
  vm_datastore_id = "local-nvme"
  vm_description  = "Managed by OpenTofu"
  vm_disk_size    = 128
  vm_id           = 99991023
  vm_name         = "data_ram"
  vm_tags         = ["NE_PAS_SUPPRIMER", "stateful", "talos"]
}

### VMs de production
# module "tesla" {
#   source  = "./modules/pve-vm"
#   enabled = "1"

#   cloudinit_dns_domain   = "dc.local.hommet.net"
#   cloudinit_dns_servers  = ["9.9.9.9", "1.1.1.1"]
#   cloudinit_ssh_keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
#   cloudinit_user_account = "jho"
#   node_name              = "miniquarium"
#   pve_api_token          = data.sops_file.pve_secrets.data["pve_api_token"]
#   pve_host_address       = data.sops_file.pve_secrets.data["pve_endpoint"]
#   tags                   = ["debian12", "opentofu"]
#   vm_bridge_lan          = "vmbr0"
#   vm_cpu_cores_number    = 1
#   vm_cpu_type            = "x86-64-v2-AES"
#   vm_datastore_id        = "local-nvme"
#   vm_description         = "`tesla`. Managed by OpenTofu. Tools installed: `cockpit`, `netdata`, `nut`."
#   vm_disk_size           = 32
#   vm_gateway_ipv4        = "192.168.1.254"
#   vm_id                  = 10031
#   vm_ipv4_address        = "192.168.1.31"
#   vm_memory_max          = 2048
#   vm_memory_min          = 1024
#   vm_name                = "tesla"
#   vm_socket_number       = 1
#   vm_startup_order       = "1"
# }
