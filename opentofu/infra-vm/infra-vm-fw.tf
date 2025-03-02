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
    type    = "in"
  }
}
