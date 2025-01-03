cluster_name     = "talosk8sv1"
cluster_endpoint = "https://192.168.1.200:6443" # The cluster_endpoint variable should have the form https://<control-plane-ip-or-vip-or-dns-name>:6443.
node_data = {
  controlplanes = {
    "192.168.1.200" = {
      install_disk = "/dev/sda"
      hostname     = "dodge"
    }
  }
  workers = {
    "192.168.1.201" = {
      install_disk = "/dev/sda"
      hostname     = "ram"
    }
    "192.168.1.202" = {
      install_disk = "/dev/sda"
      hostname     = "viper"
    }
  }
}