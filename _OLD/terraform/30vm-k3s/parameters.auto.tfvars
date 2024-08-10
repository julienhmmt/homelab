clone_node_name        = "w3p243"
clone_vm_id            = 99999 # ubuntu24
cloudinit_dns_domain   = "local.hommet.net"
cloudinit_dns_servers  = ["172.16.0.1"]
cloudinit_ssh_keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEHKEQ6FLrn8b85ClMxvu04DbAiyMZ5tf5ktL4xEpSZ mettmett@JH-LVL10"]
cloudinit_user_account = "jho"
datastore_id           = "vm"
disk_file_format       = "raw"
net_rate_limit         = 100
pve_api_token          = "terrabot@pve!magic=e74b78f1-19fb-4cd3-aa31-b0c23edcf712"
pve_host_address       = "https://192.168.1.1:8006"
tmp_dir                = "/tmp"
vm_bridge_lan          = "vmbr0"
vm_cpu_cores_number    = 2
vm_cpu_type            = "x86-64-v2-AES"
vm_description         = "Managed by terraform."
vm_disk_size           = 64
vm_socket_number       = 1
