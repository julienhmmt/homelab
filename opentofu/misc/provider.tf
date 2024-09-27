terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.64.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
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

provider "sops" {}

data "sops_file" "pve_secrets" {
  source_file = "pve_secrets.yaml"
}
