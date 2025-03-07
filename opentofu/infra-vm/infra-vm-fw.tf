resource "proxmox_virtual_environment_cluster_firewall_security_group" "cockpit" {
  name    = "cockpit"
  comment = "Managed by OpenTofu"

  rule {
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
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "monitoring" {
  name    = "monitoring"
  comment = "Managed by OpenTofu"

  rule {
    action  = "ACCEPT"
    comment = "Allow NETDATA"
    dest    = "192.168.1.30-192.168.1.40"
    dport   = "19999"
    enabled = true
    log     = "info"
    proto   = "tcp"
    type    = "in"
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "ssh" {
  name    = "ssh"
  comment = "Managed by OpenTofu"
  rule {
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
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "k8s_api" {
  name    = "k8s_api"
  comment = "Managed by OpenTofu"
  rule {
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
}
