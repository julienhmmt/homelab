# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "pveexporter_root_password1" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "pveexporter_root_password1" {
  value     = random_password.pveexporter_root_password1.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "pveexporter_1" {
  description   = "Used only for PVE Exporter. Managed by Terraform"
  node_name     = "w3p241"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 241224

  cpu {
    architecture = "amd64"
    cores        = 1
  }

  disk {
    datastore_id = var.ct_datastore_storage_location
    size         = var.ct_disk_size
  }

  memory {
    dedicated = var.ct_memory
    swap      = 0
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.debian_container_template.id
    type             = var.os_type
  }

  initialization {
    hostname = "pveexporter-w3p241"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.224/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.pveexporter_root_password1.result
    }
  }
  network_interface {
    name       = var.ct_bridge
    rate_limit = var.ct_nic_rate_limit
  }

  features {
    nesting = true
    fuse    = false
  }
}

###
resource "random_password" "pveexporter_root_password2" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "pveexporter_root_password2" {
  value     = random_password.pveexporter_root_password2.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "pveexporter_2" {
  description   = "Used only for PVE Exporter. Managed by Terraform"
  node_name     = "w3p242"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 242225

  cpu {
    architecture = "amd64"
    cores        = 1
  }

  disk {
    datastore_id = var.ct_datastore_storage_location
    size         = var.ct_disk_size
  }

  memory {
    dedicated = var.ct_memory
    swap      = 0
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.debian_container_template.id
    type             = var.os_type
  }

  initialization {
    hostname = "pveexporter-w3p242"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.225/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.pveexporter_root_password2.result
    }
  }
  network_interface {
    name       = var.ct_bridge
    rate_limit = var.ct_nic_rate_limit
  }

  features {
    nesting = true
    fuse    = false
  }
}

###
resource "random_password" "pveexporter_root_password3" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "pveexporter_root_password3" {
  value     = random_password.pveexporter_root_password3.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "pveexporter_3" {
  description   = "Used only for PVE Exporter. Managed by Terraform"
  node_name     = "w3p243"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 243226

  cpu {
    architecture = "amd64"
    cores        = 1
  }

  disk {
    datastore_id = var.ct_datastore_storage_location
    size         = var.ct_disk_size
  }

  memory {
    dedicated = var.ct_memory
    swap      = 0
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.debian_container_template.id
    type             = var.os_type
  }

  initialization {
    hostname = "pveexporter-w3p243"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.226/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.pveexporter_root_password3.result
    }
  }
  network_interface {
    name       = var.ct_bridge
    rate_limit = var.ct_nic_rate_limit
  }

  features {
    nesting = true
    fuse    = false
  }
}
