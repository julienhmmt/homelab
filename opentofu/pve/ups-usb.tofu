resource "proxmox_virtual_environment_hardware_mapping_usb" "ups" {
  comment = "UPS Eaton 3S"
  name    = "ups"
  map = [
    {
      comment = "UPS Eaton USB"
      id      = "0463:ffff"
      node    = "miniquarium"
    },
  ]
}