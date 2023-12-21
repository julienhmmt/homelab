terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.41.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_host_address
  api_token = var.pve_api_token
  insecure  = true
  ssh {
    agent    = true
    username = var.pve_api_user
  }
  tmp_dir = var.tmp_dir
}
