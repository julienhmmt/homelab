terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.76.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "proxmox" {
  api_token = data.sops_file.pve_secrets.data["pve_api_token"]
  endpoint  = data.sops_file.pve_secrets.data["pve_endpoint"]
  insecure  = false
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

provider "talos" {}
