firewall_aliases = {
  local_network = {
    cidr    = "172.16.255.0/24"
    comment = "Managed by OpenTofu. Réseau local."
  }
  vm1 = {
    cidr    = "172.16.255.30/24"
    comment = "Managed by OpenTofu. VM 1"
  }
  gw = {
    cidr    = "172.16.255.250/24"
    comment = "Managed by OpenTofu. GW"
  }
}

firewall_security_groups = {
  cockpit = {
    comment = "Managed by OpenTofu. Access to Cockpit from local machines to infra VMs."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow COCKPIT"
        dest    = "172.16.255.30-172.16.255.40"
        dport   = "9090"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "172.16.255.1-172.16.255.3"
        type    = "in"
      }
    ]
  }
  ssh = {
    comment = "Managed by OpenTofu. Access to SSH from local machines to infra VMs."
    rules = [
      {
        action  = "ACCEPT"
        comment = "Allow SSH"
        dest    = "172.16.255.30-172.16.255.40"
        dport   = "22"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "172.16.255.1-172.16.255.3"
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
        dest    = "172.16.255.21"
        dport   = "6443"
        enabled = true
        log     = "info"
        proto   = "tcp"
        source  = "172.16.255.2,172.16.255.3,172.16.255.240,172.16.255.241,172.16.255.242"
        type    = "in"
      }
    ]
  }
}
