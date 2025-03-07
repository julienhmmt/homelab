firewall_aliases = {
  local_network = {
    cidr    = "192.168.1.0/24"
    comment = "Managed by OpenTofu. Réseau local."
  }
  pbs_vm = {
    cidr    = "192.168.1.30/24"
    comment = "Managed by OpenTofu. VM Proxmox Backup Server."
  }
  tesla_vm = {
    cidr    = "192.168.1.10/24"
    comment = "Managed by OpenTofu. VM qui supporte l'onduleur."
  }
  charger_vm = {
    cidr    = "192.168.1.11/24"
    comment = "Managed by OpenTofu. VM d'infrastructure pour le stockage."
  }
  k8s_vm_cp = {
    cidr    = "192.168.1.21/24"
    comment = "Managed by OpenTofu. VM K8S ayant le rôle de maître."
  }
  k8s_vm_wrk1 = {
    cidr    = "192.168.1.22/24"
    comment = "Managed by OpenTofu. VM K8S ayant le rôle de worker."
  }
  k8s_vm_wrk2 = {
    cidr    = "192.168.1.23/24"
    comment = "Managed by OpenTofu. VM K8S ayant le rôle de worker."
  }
  gw_fbox = {
    cidr    = "192.168.1.254/24"
    comment = "Managed by OpenTofu. Routeur."
  }
  dns_cf = {
    cidr    = "1.1.1.1"
    comment = "Managed by OpenTofu. DNS public Cloudflare."
  }
  dns_fbox = {
    cidr    = "192.168.1.254/24"
    comment = "Managed by OpenTofu. DNS local Freebox."
  }
}
