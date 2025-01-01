terraform {
  required_providers {
    proxmox = {
      source  = "siderolabs/talos"
      version = "~> 0.7"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
}

provider "sops" {}

# data "sops_file" "pve_secrets" {
#   source_file = "pve_secrets.yaml"
# }
