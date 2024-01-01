bios_type                = "seabios"
boot_command             = "<wait3>c<wait3>linux /casper/vmlinuz quiet autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/22.04/proxmox/' <enter><wait5>initrd /casper/initrd<wait5><enter>boot<wait5s><enter>"
boot_wait                = "10s"
bridge_name              = "vmbr0"
iso_checksum             = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
iso_download_pve         = true
iso_storage_pool         = "stoCephfs"
iso_url                  = "https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
machine_default_type     = "q35"
os_type                  = "l26"
proxmox_api_token_id     = "packbot@pve!packer"
proxmox_api_token_secret = "82da59e5-6bbe-44eb-ae35-359235d59b37"
proxmox_api_url          = "https://172.16.3.2:8006/api2/json"
proxmox_node             = "w3p243"
qemu_agent_activation    = true
scsi_controller_type     = "virtio-scsi-pci"
ssh_timeout              = "5m"
tags                     = "template"
template_cpu_type        = "kvm64"
template_description     = "Ubuntu Jammy (22.04) Packer Template"
template_disk_discard    = true
template_disk_format     = "qcow2"
template_disk_size       = "12G"
template_disk_type       = "virtio"
template_name            = "ghost_ubuntu22"
template_nb_core         = 1
template_nb_cpu          = 1
template_nb_ram          = 1024
template_ssh_username    = "jho"
template_storage_pool    = "stoCephfs"
template_sudo_password   = "pouetpouet"
template_vm_id           = 99999
