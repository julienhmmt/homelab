resource "proxmox_virtual_environment_hosts" "host_entries" {
  node_name = "miniquarium"

  entry {
    address = "127.0.0.1"
    hostnames = [
      "localhost",
      "localhost.localdomain",
      "miniquarium",
      "miniquarium.prive.dc.local.hommet.net"
    ]
  }

  entry {
    address = "192.168.1.1"
    hostnames = [
      "miniquarium",
      "miniquarium.prive.dc.local.hommet.net"
    ]
  }

  entry {
    address = "192.168.1.2"
    hostnames = [
      "dns",
      "dns.prive.dc.local.hommet.net",
      "adguard",
      "adguard.prive.dc.local.hommet.net"
    ]
  }

  entry {
    address = "192.168.1.254"
    hostnames = [
      "gw",
      "gw.prive.dc.local.hommet.net",
      "freebox",
      "freebox.prive.dc.local.hommet.net"
    ]
  }
}