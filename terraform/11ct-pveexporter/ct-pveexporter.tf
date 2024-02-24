// Container PVE Exporter

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

resource "proxmox_virtual_environment_file" "debian_container_template" {
  content_type = "vztmpl"
  datastore_id = var.ct_datastore_template_location
  node_name    = "w3p241"

  source_file {
    path = var.ct_source_file_path
  }
}

resource "proxmox_virtual_environment_hagroup" "ha_infra" {
  group   = "ha_infra"
  comment = "Managed by Terraform. Group for HA, specially infra CT & VM"
  nodes = {
    node1 = null
    node2 = 2
    node3 = 1
  }

  restricted  = true
  no_failback = false
}

resource "proxmox_virtual_environment_container" "pveexporter_1" {
  description   = "Used only for PVE Exporter. Managed by Terraform"
  node_name     = "w3p241"
  pool_id       = "infra"
  start_on_boot = true
  tags          = ["linux", "infra", "monitoring"]
  unprivileged  = true
  vm_id         = 241002

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
    hostname = "pveexporter"

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = "172.16.241.3/16"
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

resource "proxmox_virtual_environment_haresource" "pveexporter_ct" {
  comment      = "Managed by Terraform"
  group        = "ha_infra"
  max_relocate = 1
  max_restart  = 1
  resource_id  = "ct:${split(":", proxmox_virtual_environment_container.pveexporter_1.vm_id)[0]}"
  state        = "started"
}
