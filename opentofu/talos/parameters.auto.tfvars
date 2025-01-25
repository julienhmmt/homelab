cluster_name     = "localhommetnet_k8sv1"
cluster_endpoint = "https://192.168.1.21:6443" # The cluster_endpoint variable should have the form https://<control-plane-ip-or-vip-or-dns-name>:6443.
node_data = {
  controlplanes = {
    "192.168.1.21" = {
      install_disk = "/dev/sda"
      hostname     = "dodge"
    }
  }
  workers = {
    "192.168.1.22" = {
      install_disk = "/dev/sda"
      hostname     = "ram"
    }
    "192.168.1.23" = {
      install_disk = "/dev/sda"
      hostname     = "viper"
    }
  }
}