packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntujammy" {
  bios                     = "seabios"
  boot_command             = "${var.boot_command}"
  boot_wait                = "${var.boot_wait}s"
  cores                    = "${var.template_nb_core}"
  cpu_type                 = "${var.template_cpu_type}"
  http_directory           = "http"
  http_port_min            = 8100
  http_port_max            = 8100
  insecure_skip_tls_verify = true
  iso_file                 = "${var.iso_storage_pool}/${var.iso_url}"
  iso_checksum             = "${var.iso_checksum}"
  iso_download_pve         = true
  machine                  = "q35"
  memory                   = "${var.template_nb_ram}"
  node                     = "${var.proxmox_node}"
  os                       = "l26"
  proxmox_url              = "${var.proxmox_api_url}"
  qemu_agent               = "${var.qemu_agent_activation}"
  scsi_controller          = "${var.scsi_controller_type}"
  ssh_username             = "${var.template_ssh_username}"
  ssh_password             = "${var.template_sudo_password}"
  ssh_timeout              = "${var.ssh_timeout}"
  sockets                  = "${var.template_nb_cpu}"
  tags                     = "${var.tags}"
  template_description     = "Ubuntu Jammy (22.04) Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  token                    = "${var.proxmox_api_token_secret}"
  unmount_iso              = true
  username                 = "${var.proxmox_api_token_id}"
  vm_name                  = "${var.template_name}"
  vm_id                    = "${var.template_vm_id}"

  disks {
    disk_size    = "${var.template_disk_size}"
    format       = "${var.template_disk_format}"
    storage_pool = "${var.template_storage_pool}"
    type         = "scsi"
  }

  network_adapters {
    bridge   = "${var.bridge_name}"
    firewall = true
    model    = "virtio"
  }
}

build {
  sources = ["source.proxmox-iso.ubuntujammy"]
  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean", "sudo passwd -d ubuntu"]
  }
}
