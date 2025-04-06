kubernetes_version     = "1.31.6"
kubernetes_dns_domain  = "k8s.local.hommet.net"
talos_cluster_name     = "localhommetnet_k8sv1"
talos_cluster_endpoint = "192.168.1.21"
talos_version          = "1.9.4"

meta_config_metadata = {
  "dodge" = {
    snippet_datastore_id = "local"
    snippet_pve          = "miniquarium"
    data                 = <<-EOF
      instance-id: talos-dodge
      local-hostname: dodge
    EOF
  }

  # "ram" = {
  #   snippet_datastore_id = "local"
  #   snippet_pve          = "miniquarium"
  #   data                 = <<-EOF
  #     instance-id: talos-ram
  #     local-hostname: ram
  #   EOF
  # }

  "viper" = {
    snippet_datastore_id = "local"
    snippet_pve          = "miniquarium"
    data                 = <<-EOF
      instance-id: talos-viper
      local-hostname: viper
    EOF
  }
}

nodes = {
  "dodge" = {
    pve          = "miniquarium"
    role         = "controlplane"
    usage        = "controlplane"
    vm_cpu_cores = 2
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "x86-64-v2-AES"
    vm_datastore_id                = "local-nvme"
    vm_datastore_id_efi_disk       = "local-nvme"
    vm_datastore_id_initialization = "local-nvme"
    vm_datastore_id_tpm            = "local-nvme"
    vm_description                 = "Managed by OpenTofu. Talos controlplane"
    vm_disk_size                   = 64
    vm_dns                         = ["192.168.1.254", "1.1.1.1"]
    vm_domain                      = "dc.local.hommet.net"
    vm_efi                         = true
    vm_eth_rate_limit              = 0
    vm_gateway                     = "192.168.1.254"
    vm_id                          = 121
    vm_install_disk                = "/dev/sda"
    vm_ip                          = "192.168.1.21"
    vm_kvm_args                    = ""
    vm_mac_address                 = "BC:24:11:CA:FE:21"
    vm_memory_dedicated            = 4096
    vm_memory_floating             = 4096
    vm_name                        = "dodge"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_startup_order               = 2
    vm_started                     = true
    vm_tags                        = ["controlplane", "k8s", "opentofu", "talos"]
    vm_timeservers                 = ["fr.pool.ntp.org", "time.cloudflare.com"]
    vm_tpm                         = true
  }

  # "ram" = {
  #   pve          = "miniquarium"
  #   role         = "worker"
  #   usage        = "infra"
  #   vm_cpu_cores = 2
  #   # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
  #   vm_cpu_type                    = "x86-64-v2-AES"
  #   vm_datastore_id                = "local-nvme"
  #   vm_datastore_id_efi_disk       = "local-nvme"
  #   vm_datastore_id_initialization = "local-nvme"
  #   vm_datastore_id_tpm            = "local-nvme"
  #   vm_description                 = "Managed by OpenTofu. Talos worker for infrastructure service"
  #   vm_disk_size                   = 64
  #   vm_dns                         = ["192.168.1.254", "1.1.1.1"]
  #   vm_domain                      = "dc.local.hommet.net"
  #   vm_efi                         = true
  #   vm_eth_rate_limit              = 0
  #   vm_gateway                     = "192.168.1.254"
  #   vm_id                          = 122
  #   vm_install_disk                = "/dev/sda"
  #   vm_ip                          = "192.168.1.22"
  #   vm_kvm_args                    = ""
  #   vm_mac_address                 = "BC:24:11:CA:FE:22"
  #   vm_memory_dedicated            = 16384 # 16 GB
  #   vm_memory_floating             = 16384 # 16 GB
  #   vm_name                        = "ram"
  #   vm_on_boot                     = true
  #   vm_pool_id                     = ""
  #   vm_started                     = true
  #   vm_startup_order               = 3
  #   vm_tags                        = ["k8s", "opentofu", "talos", "worker"]
  #   vm_tpm                         = true
  # }

  "viper" = {
    pve          = "miniquarium"
    role         = "worker"
    usage        = "general"
    vm_cpu_cores = 6
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "host"
    vm_datastore_id                = "local-nvme"
    vm_datastore_id_efi_disk       = "local-nvme"
    vm_datastore_id_initialization = "local-nvme"
    vm_datastore_id_tpm            = "local-nvme"
    vm_description                 = "Managed by OpenTofu. Talos worker for everything"
    vm_disk_size                   = 64
    vm_dns                         = ["192.168.1.254", "1.1.1.1"]
    vm_domain                      = "dc.local.hommet.net"
    vm_efi                         = true
    vm_eth_rate_limit              = 0
    vm_gateway                     = "192.168.1.254"
    vm_id                          = 123
    vm_install_disk                = "/dev/sda"
    vm_ip                          = "192.168.1.23"
    vm_kvm_args                    = ""
    vm_mac_address                 = "BC:24:11:CA:FE:23"
    vm_memory_dedicated            = 24576 # 24 GB
    vm_memory_floating             = 24576 # 24 GB
    vm_name                        = "viper"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_startup_order               = 4
    vm_started                     = true
    vm_tags                        = ["k8s", "opentofu", "talos", "worker"]
    vm_timeservers                 = ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"]
    vm_tpm                         = true
  }
}
