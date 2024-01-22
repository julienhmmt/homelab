// VM Master

resource "proxmox_virtual_environment_vm" "rke2vm1_w3p241" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "MasterNode"
  node_name       = "w3p241"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "rke2", "production", "master", "ubuntu"]
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

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config {
      ipv4 {
        address = "172.16.241.10/16"
        gateway = "172.16.0.1"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 6144
    floating  = 4096
  }

  network_device {
    bridge = var.vm_bridge
    model  = "virtio"
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

// VM 2
resource "proxmox_virtual_environment_vm" "rke2vm1_w3p242" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "WorkerNode1"
  node_name       = "w3p242"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "rke2", "production", "slave", "ubuntu"]
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

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config {
      ipv4 {
        address = "172.16.242.10/16"
        gateway = "172.16.0.1"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 6144
    floating  = 4096
  }

  network_device {
    bridge = var.vm_bridge
    model  = "virtio"
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


// VM 3
resource "proxmox_virtual_environment_vm" "rke2vm1_w3p243" {
  description     = var.vm_description
  keyboard_layout = "fr"
  machine         = "q35"
  migrate         = true
  name            = "WorkerNode2"
  node_name       = "w3p243"
  pool_id         = "production"
  scsi_hardware   = "virtio-scsi-single"
  started         = true
  tablet_device   = false
  tags            = ["linux", "rke2", "production", "slave", "ubuntu"]
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

  initialization {
    datastore_id = var.datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config {
      ipv4 {
        address = "172.16.243.10/16"
        gateway = "172.16.0.1"
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = 6144
    floating  = 4096
  }

  network_device {
    bridge = var.vm_bridge
    model  = "virtio"
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
