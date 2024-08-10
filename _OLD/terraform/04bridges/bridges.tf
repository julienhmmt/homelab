resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0_w3p241" {
  node_name = "w3p241"
  name      = "vmbr0"
  comment   = "public WAN"
  ports = [
    "enp1s0"
  ]
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0_w3p242" {
  node_name = "w3p242"
  name      = "vmbr0"
  comment   = "public WAN"
  ports = [
    "enp1s0"
  ]
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0_w3p243" {
  node_name = "w3p243"
  name      = "vmbr0"
  comment   = "public WAN"
  ports = [
    "enp1s0"
  ]
}
