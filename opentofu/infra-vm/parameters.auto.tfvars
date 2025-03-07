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

firewall_security_groups = {
  cockpit = {
    comment = "Managed by OpenTofu. Access to Cockpit from JH machines to infra VMs."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow COCKPIT"
        dest    = "192.168.1.30-192.168.1.40"
        dport   = "9090"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "192.168.1.1-192.168.1.3"
        type    = "in"
      }
    ]
  }
  monitoring = {
    comment = "Managed by OpenTofu. Access to monitoring tools (Netdata) from JH machines to infra VMs."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow NETDATA"
        dest    = "192.168.1.30-192.168.1.40"
        dport   = "19999"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "192.168.1.1-192.168.1.3"
        type    = "in"
      }
    ]
  }
  ssh = {
    comment = "Managed by OpenTofu. Access to SSH from JH machines to infra VMs."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow SSH"
        dest    = "192.168.1.30-192.168.1.40"
        dport   = "22"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "192.168.1.1-192.168.1.3"
        type    = "in"
      }
    ]
  }
  k8s_api = {
    comment = "Managed by OpenTofu. Access to K8S API from JH machines and Kubernetes workers VM to Kubernetes control plane VM."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow K8S API"
        dest    = "192.168.1.21"
        dport   = "6443"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "192.168.1.2,192.168.1.3,192.168.1.21,192.168.1.22,192.168.1.23"
        type    = "in"
      }
    ]
  }
}
