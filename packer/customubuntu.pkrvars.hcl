bios_type                = "seabios"
boot                     = "c"
boot_command             = "<esc><wait>e<wait><down><down><down><end><bs><bs><bs><bs><wait>autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait><f10><wait>"
boot_wait                = "10s"
bridge_name              = "vmbr0"
bridge_firewall          = false
cloud_init               = true
cpu_type                 = "x86-64-v2-AES"
disk_discard             = true
disk_format              = "raw"
disk_size                = "12G"
disk_type                = "scsi"
iso_file                 = "stoCephfs:iso/ubuntu-22.04.3-live-server-amd64.iso"
machine_default_type     = "q35"
nb_core                  = 1
nb_cpu                   = 1
nb_ram                   = 2048
network_model            = "virtio"
io_thread                = false
os_type                  = "l26"
proxmox_api_token_id     = "packbot@pve!packer"
proxmox_api_token_secret = "da98950b-40f3-47da-a432-8b6a027fc0fb"
proxmox_api_url          = "https://172.16.3.2:8006/api2/json"
proxmox_node             = "w3p243"
qemu_agent_activation    = true
scsi_controller_type     = "virtio-scsi-pci"
ssh_handshake_attempts   = 6
ssh_private_key_file     = "packerbuilder"
ssh_timeout              = "35m"
ssh_username             = "jho"
storage_pool             = "stoCeph"
tags                     = "template"
vm_id                    = 99999
vm_info                  = "Ubuntu Jammy (22.04) Packer Template"
vm_name                  = "pckr-ubuntu"
