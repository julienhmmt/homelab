resource "proxmox_virtual_environment_vm" "vm" {

  description         = var.vm_description
  keyboard_layout     = "fr"
  machine             = "q35"
  migrate             = true
  name                = var.vm_name
  node_name           = var.node_name
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  stop_on_destroy     = true
  tablet_device       = false
  tags                = var.tags
  timeout_create      = 180
  timeout_shutdown_vm = 30
  timeout_stop_vm     = 30
  vm_id               = var.vm_id

  agent {
    enabled = true
    timeout = "5m"
    trim    = true
  }

  cpu {
    cores   = var.vm_cpu_cores_number
    flags   = []
    numa    = true
    sockets = var.vm_socket_number
    type    = var.vm_cpu_type
  }

  disk {
    aio          = "native"
    cache        = "none"
    datastore_id = var.vm_datastore_id
    discard      = "on"
    file_format  = "raw"
    file_id      = "local:iso/${var.vm_img_name}"
    interface    = "scsi0"
    iothread     = true
    replicate    = false
    size         = var.vm_disk_size
  }

  efi_disk {
    datastore_id      = var.vm_datastore_id
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = var.vm_datastore_id
    dns {
      domain  = var.cloudinit_dns_domain
      servers = var.cloudinit_dns_servers
    }
    ip_config {
      ipv4 {
        address = "${var.vm_ipv4_address}/16"
        gateway = var.vm_gateway_ipv4
      }
    }
    user_account {
      keys     = var.cloudinit_ssh_keys
      username = var.cloudinit_user_account
    }
  }

  memory {
    dedicated = var.vm_memory_max
    floating  = var.vm_memory_min
  }

  network_device {
    bridge = var.vm_bridge_lan
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  startup {
    order      = var.vm_startup_order
    up_delay   = 15
    down_delay = 30
  }

  serial_device {}

  tpm_state {
    datastore_id = var.vm_datastore_id
    version      = "v2.0"
  }

  vga {
    type = "virtio"
  }
}
