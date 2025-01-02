resource "proxmox_virtual_environment_hardware_mapping_usb" "ups" {
  count   = var.hostname == "tesla" ? 1 : 0 # Only create this resource when hostname is "tesla"
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