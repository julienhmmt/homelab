ct_bridge                      = "vmbr0"
ct_datastore_storage_location  = "stoCeph"
ct_datastore_template_location = "misc-cephfs"
ct_disk_size                   = "20"
ct_nic_rate_limit              = 10
ct_memory                      = 128
ct_source_file_path            = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
dns_domain                     = "local.hommet.net"
dns_servers                    = ["192.168.1.254", "9.9.9.9"]
gateway                        = "192.168.1.254"
os_type                        = "debian"
pve_api_token                  = "terrabot@pve!tf=31a59846-cb77-4f86-922b-8c873a92727e"
pve_api_user                   = "terrabot"
pve_host_address               = "https://192.168.1.241:8006"
tmp_dir                        = "/var/tmp"
