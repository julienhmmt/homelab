terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.76.0"
    }
    # sops = {
    #   source  = "carlpett/sops"
    #   version = "1.2.0"
    # }
  }
}

provider "proxmox" {
  api_token = var.pve_api_token
  endpoint  = var.pve_api_endpoint
  insecure  = false
  tmp_dir   = "/var/tmp/"

  ssh {
    agent    = true
    username = "root"
  }
}

# provider "sops" {}

# data "sops_file" "pve_secrets" {
#   source_file = "pve_secrets.yaml"
# }
