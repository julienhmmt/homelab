# options générales du firewall, au niveau "datacenter"
resource "proxmox_virtual_environment_cluster_firewall" "this" {
  ebtables      = false
  enabled       = true
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = false
    burst   = 10
    rate    = "5/second"
  }
}

# alias
resource "proxmox_virtual_environment_firewall_alias" "local_network" {
  name    = "local_network"
  cidr    = "192.168.1.0/24"
  comment = "Managed by OpenTofu. Réseau local."
}

resource "proxmox_virtual_environment_firewall_alias" "pbs_vm" {
  name    = "durango"
  cidr    = "192.168.1.30/24"
  comment = "Managed by OpenTofu. VM Proxmox Backup Server."
}
resource "proxmox_virtual_environment_firewall_alias" "tesla_vm" {
  name    = proxmox_virtual_environment_vm.vm_tesla.name
  cidr    = proxmox_virtual_environment_vm.vm_tesla.initialization.0.ip_config.0.ipv4[0].address
  comment = "Managed by OpenTofu. VM qui supporte l'onduleur."
}
resource "proxmox_virtual_environment_firewall_alias" "charger_vm" {
  name    = proxmox_virtual_environment_vm.vm_charger.name
  cidr    = proxmox_virtual_environment_vm.vm_charger.initialization.0.ip_config.0.ipv4[0].address
  comment = "Managed by OpenTofu. VM d'infrastructure pour le stockage."
}
resource "proxmox_virtual_environment_firewall_alias" "k8s_vm_cp" {
  name    = "k8s_cp"
  cidr    = "192.168.1.21/24"
  comment = "Managed by OpenTofu. VM K8S ayant le rôle de maître."
}
resource "proxmox_virtual_environment_firewall_alias" "k8s_vm_wrk1" {
  name    = "k8s_wrk1"
  cidr    = "192.168.1.22/24"
  comment = "Managed by OpenTofu. VM K8S ayant le rôle de worker."
}
resource "proxmox_virtual_environment_firewall_alias" "k8s_vm_wrk2" {
  name    = "k8s_wrk2"
  cidr    = "192.168.1.23/24"
  comment = "Managed by OpenTofu. VM K8S ayant le rôle de worker."
}
resource "proxmox_virtual_environment_firewall_alias" "gw" {
  name    = "gw"
  cidr    = "192.168.1.254/24"
  comment = "Managed by OpenTofu. Routeur."
}
resource "proxmox_virtual_environment_firewall_alias" "dns_cf" {
  name    = "dns_cf"
  cidr    = "1.1.1.1"
  comment = "Managed by OpenTofu. DNS public Cloudflare."
}

# groupes de sécurité pour les vm
resource "proxmox_virtual_environment_cluster_firewall_security_group" "cockpit" {
  comment = "Managed by OpenTofu. Access to Cockpit from JH machines to infra VMs."
  name    = "cockpit"

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
  comment = "Managed by OpenTofu. Access to monitoring tools (Netdata) from JH machines to infra VMs."
  name    = "monitoring"

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
  comment = "Managed by OpenTofu. Access to SSH from JH machines to infra VMs."
  name    = "ssh"

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
  comment = "Managed by OpenTofu. Access to K8S API from JH machines and Kubernetes workers VM to Kubernetes control plane VM."
  name    = "k8s_api"

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
