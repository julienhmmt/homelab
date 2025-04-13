kubernetes_version     = "1.31.6"
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

  "ram" = {
    snippet_datastore_id = "local"
    snippet_pve          = "miniquarium"
    data                 = <<-EOF
      instance-id: talos-ram
      local-hostname: ram
    EOF
  }

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
    data_vm_interface_disk = "scsi10" # port on the data VM disk
    pve                    = "miniquarium"
    role                   = "controlplane"
    usage                  = "controlplane"
    vm_boot_disk_format    = "raw"
    vm_boot_disk_size      = 24
    vm_cpu_cores           = 2
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "x86-64-v2-AES"
    vm_data_disk_interface         = "scsi1" # port on the control plane VM
    vm_datastore_id                = "local-nvme"
    vm_datastore_id_boot_disk      = "local-nvme"
    vm_datastore_id_data_disk      = "local-nvme"
    vm_datastore_id_efi_disk       = "local-nvme"
    vm_datastore_id_initialization = "local-nvme"
    vm_datastore_id_tpm            = "local-nvme"
    vm_description                 = "Managed by OpenTofu. Talos controlplane"
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
    vm_memory_dedicated            = 6144
    vm_memory_floating             = 6144
    vm_name                        = "dodge"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_started                     = true
    vm_startup_order               = 2
    vm_tags                        = ["controlplane", "k8s", "opentofu", "talos"]
    vm_timeservers                 = ["fr.pool.ntp.org", "time.cloudflare.com"]
    vm_tpm                         = true
  }

  "ram" = {
    data_vm_interface_disk = "scsi11" # port on the data VM disk
    pve                    = "miniquarium"
    role                   = "worker"
    usage                  = "infra"
    vm_boot_disk_format    = "raw"
    vm_boot_disk_size      = 24
    vm_cpu_cores           = 3
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "x86-64-v2-AES"
    vm_data_disk_interface         = "scsi1" # port on the worker VM
    vm_datastore_id                = "local-nvme"
    vm_datastore_id_boot_disk      = "local-nvme"
    vm_datastore_id_data_disk      = "local-nvme"
    vm_datastore_id_efi_disk       = "local-nvme"
    vm_datastore_id_initialization = "local-nvme"
    vm_datastore_id_tpm            = "local-nvme"
    vm_description                 = "Managed by OpenTofu. Talos worker"
    vm_dns                         = ["192.168.1.254", "1.1.1.1"]
    vm_domain                      = "dc.local.hommet.net"
    vm_efi                         = true
    vm_eth_rate_limit              = 0
    vm_gateway                     = "192.168.1.254"
    vm_id                          = 122
    vm_install_disk                = "/dev/sda"
    vm_ip                          = "192.168.1.22"
    vm_kvm_args                    = ""
    vm_mac_address                 = "BC:24:11:CA:FE:22"
    vm_memory_dedicated            = 16384 # 16 GB
    vm_memory_floating             = 16384 # 16 GB
    vm_name                        = "ram"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_started                     = true
    vm_startup_order               = 3
    vm_tags                        = ["k8s", "opentofu", "talos", "worker"]
    vm_timeservers                 = ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"]
    vm_tpm                         = true
  }

  "viper" = {
    data_vm_interface_disk = "scsi12" # port on the data VM disk
    pve                    = "miniquarium"
    role                   = "worker"
    usage                  = "general"
    vm_boot_disk_format    = "raw"
    vm_boot_disk_size      = 24
    vm_cpu_cores           = 3
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "host"
    vm_data_disk_interface         = "scsi1" # port on the worker VM
    vm_datastore_id                = "local-nvme"
    vm_datastore_id_boot_disk      = "local-nvme"
    vm_datastore_id_data_disk      = "local-nvme"
    vm_datastore_id_efi_disk       = "local-nvme"
    vm_datastore_id_initialization = "local-nvme"
    vm_datastore_id_tpm            = "local-nvme"
    vm_description                 = "Managed by OpenTofu. Talos worker"
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
    vm_memory_dedicated            = 16384 # 16 GB
    vm_memory_floating             = 16384 # 16 GB
    vm_name                        = "viper"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_started                     = true
    vm_startup_order               = 4
    vm_tags                        = ["k8s", "opentofu", "talos", "worker"]
    vm_timeservers                 = ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"]
    vm_tpm                         = true
  }
}
