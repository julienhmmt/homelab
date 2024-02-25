// VM Master1

resource "proxmox_virtual_environment_vm" "vm1_w3p241" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "MasterNode1"
  node_name       = "w3p241"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "k3s", "production", "master", "debian12"]
  vm_id           = 241010

  clone {
    datastore_id = var.datastore_id
    full         = true
    node_name    = var.clone_node_name
    retries      = 2
    vm_id        = var.clone_vm_id
  }

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores   = var.vm_cpu_cores_number
    numa    = true
    sockets = var.vm_socket_number
    type    = var.vm_cpu_type
  }

  disk {
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi0"
    iothread     = true
    size         = var.vm_disk_size
  }

  disk { # stockage for k3s (longhorn)
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi1"
    iothread     = true
    size         = 64
  }

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config { // net0 - LAN
      ipv4 {
        address = "172.16.241.10/16"
        gateway = "172.16.0.1"
      }
    }
    ip_config { // net1 - MONITORING
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 8192
    floating  = 4096
  }

  network_device {
    bridge     = var.vm_bridge_lan
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  network_device {
    bridge     = var.vm_bridge_monitoring
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  operating_system {
    type = "l26"
  }

  startup {
    order      = "1"
    up_delay   = "20"
    down_delay = "20"
  }

  serial_device {}
}

// MasterNode2

resource "proxmox_virtual_environment_vm" "vm1_w3p242" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "MasterNode2"
  node_name       = "w3p242"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "k3s", "production", "master", "debian12"]
  vm_id           = 242010

  clone {
    datastore_id = var.datastore_id
    full         = true
    node_name    = var.clone_node_name
    retries      = 2
    vm_id        = var.clone_vm_id
  }

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores   = var.vm_cpu_cores_number
    numa    = true
    sockets = var.vm_socket_number
    type    = var.vm_cpu_type
  }

  disk {
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi0"
    iothread     = true
    size         = var.vm_disk_size
  }

  disk { # stockage for k3s (longhorn)
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi1"
    iothread     = true
    size         = 64
  }

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config { // net0 - LAN
      ipv4 {
        address = "172.16.242.10/16"
        gateway = "172.16.0.1"
      }
    }
    ip_config { // net1 - monitoring
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 8192
    floating  = 4096
  }

  network_device {
    bridge     = var.vm_bridge_lan
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  network_device {
    bridge     = var.vm_bridge_monitoring
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  operating_system {
    type = "l26"
  }

  startup {
    order      = "2"
    up_delay   = "20"
    down_delay = "20"
  }

  serial_device {}
}


// MasterNode3
resource "proxmox_virtual_environment_vm" "vm1_w3p243" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "MasterNode3"
  node_name       = "w3p243"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "k3s", "production", "master", "debian12"]
  vm_id           = 243010

  clone {
    datastore_id = var.datastore_id
    full         = true
    node_name    = var.clone_node_name
    retries      = 2
    vm_id        = var.clone_vm_id
  }

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores   = var.vm_cpu_cores_number
    numa    = true
    sockets = var.vm_socket_number
    type    = var.vm_cpu_type
  }

  disk {
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi0"
    iothread     = true
    size         = var.vm_disk_size
  }

  disk { # stockage for k3s (longhorn)
    datastore_id = var.datastore_id
    discard      = "on"
    file_format  = var.disk_file_format
    interface    = "scsi1"
    iothread     = true
    size         = 64
  }

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config { // net0 - LAN
      ipv4 {
        address = "172.16.243.10/16"
        gateway = "172.16.0.1"
      }
    }
    ip_config { // net1 - monitoring
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 8192
    floating  = 4096
  }

  network_device {
    bridge     = var.vm_bridge_lan
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  network_device {
    bridge     = var.vm_bridge_monitoring
    model      = "virtio"
    rate_limit = var.net_rate_limit
  }

  operating_system {
    type = "l26"
  }

  startup {
    order      = "3"
    up_delay   = "20"
    down_delay = "20"
  }

  serial_device {}
}
