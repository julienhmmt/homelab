resource "proxmox_virtual_environment_hardware_mapping_usb" "onduleur" {
  comment = "UPS Eaton 3S"
  name    = "onduleur"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "miniquarium"
    },
  ]
}