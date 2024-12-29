resource "proxmox_virtual_environment_dns" "dns_configuration" {
  domain    = "prive.dc.local.hommet.net"
  node_name = "miniquarium"

  servers = [
    "192.168.1.2",
    "1.1.1.1"
  ]
}