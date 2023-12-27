// Containers

# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "nodeexporter_root_password1" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "nodeexporter_root_password1" {
  value     = random_password.nodeexporter_root_password1.result
  sensitive = true
}

# location of containers templates
resource "proxmox_virtual_environment_file" "debian_container_template" {
  content_type = "vztmpl"
  datastore_id = var.ct_datastore_template_location
  node_name    = "w3p241"

  source_file {
    path = var.ct_source_file_path
  }
}

resource "proxmox_virtual_environment_container" "nodeexporter_1" {
  description   = "Used only for Node_Exporter. Managed by Terraform"
  node_name     = "w3p241"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 241221

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
    hostname = "nodeexporter-w3p241"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.221/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.nodeexporter_root_password1.result
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
# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "nodeexporter_root_password2" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "nodeexporter_root_password2" {
  value     = random_password.nodeexporter_root_password2.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "nodeexporter_2" {
  description   = "Used only for Node_Exporter. Managed by Terraform"
  node_name     = "w3p242"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 242222

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
    hostname = "nodeexporter-w3p242"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.222/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.nodeexporter_root_password2.result
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
# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "nodeexporter_root_password3" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "nodeexporter_root_password3" {
  value     = random_password.nodeexporter_root_password3.result
  sensitive = true
}

resource "proxmox_virtual_environment_container" "nodeexporter_3" {
  description   = "Used only for Node_Exporter. Managed by Terraform"
  node_name     = "w3p243"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 243223

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
    hostname = "nodeexporter-w3p243"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.223/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
      password = random_password.nodeexporter_root_password3.result
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
