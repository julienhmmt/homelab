kubernetes_version     = "1.31.6"
talos_cluster_name     = "talosclustername"
talos_cluster_endpoint = "172.16.1.1"
talos_version          = "1.9.5"

meta_config_metadata = {
  "taloscp" = {
    snippet_datastore_id = "local"
    snippet_pve          = "pvename"
    data                 = <<-EOF
      instance-id: talos-cp
      local-hostname: taloscp
    EOF
  }

  "taloswkr" = {
    snippet_datastore_id = "local"
    snippet_pve          = "pvename"
    data                 = <<-EOF
      instance-id: talos-wkr
      local-hostname: taloswkr
    EOF
  }
}

nodes = {
  "taloscp" = {
    data_vm_interface_disk = "scsi10" # port on the data VM disk
    pve                    = "pvename"
    role                   = "controlplane"
    usage                  = "controlplane"
    vm_boot_disk_format    = "raw"
    vm_boot_disk_size      = 24
    vm_cpu_cores           = 2
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "x86-64-v2-AES"
    vm_data_disk_interface         = "scsi1" # port on the control plane VM
    vm_datastore_id                = "local"
    vm_datastore_id_boot_disk      = "local"
    vm_datastore_id_data_disk      = "local"
    vm_datastore_id_efi_disk       = "local"
    vm_datastore_id_initialization = "local"
    vm_datastore_id_tpm            = "local"
    vm_description                 = "Managed by OpenTofu. Talos controlplane"
    vm_dns                         = ["9.9.9.9"]
    vm_domain                      = "home.arpa"
    vm_efi                         = true
    vm_eth_rate_limit              = 0
    vm_gateway                     = "172.16.1.254"
    vm_id                          = 999101
    vm_install_disk                = "/dev/sda"
    vm_ip                          = "172.16.1.1"
    vm_kvm_args                    = ""
    vm_mac_address                 = "BC:24:11:FF:FF:01"
    vm_memory_dedicated            = 6144
    vm_memory_floating             = 6144
    vm_name                        = "taloscp"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_started                     = true
    vm_startup_order               = 2
    vm_tags                        = ["controlplane", "k8s", "opentofu", "talos"]
    vm_timeservers                 = ["fr.pool.ntp.org", "time.cloudflare.com"]
    vm_tpm                         = true
  }

  "taloswkr" = {
    data_vm_interface_disk = "scsi11" # port on the data VM disk
    pve                    = "pvename"
    role                   = "worker"
    usage                  = "infra"
    vm_boot_disk_format    = "raw"
    vm_boot_disk_size      = 24
    vm_cpu_cores           = 3
    # vm_cpu_flags                   = ["+aes", "+amd-ssbd", "+amd-no-ssb"]
    vm_cpu_type                    = "x86-64-v2-AES"
    vm_data_disk_interface         = "scsi1" # port on the worker VM
    vm_datastore_id                = "local"
    vm_datastore_id_boot_disk      = "local"
    vm_datastore_id_data_disk      = "local"
    vm_datastore_id_efi_disk       = "local"
    vm_datastore_id_initialization = "local"
    vm_datastore_id_tpm            = "local"
    vm_description                 = "Managed by OpenTofu. Talos worker"
    vm_dns                         = ["9.9.9.9"]
    vm_domain                      = "home.arpa"
    vm_efi                         = true
    vm_eth_rate_limit              = 0
    vm_gateway                     = "172.16.1.254"
    vm_id                          = 999102
    vm_install_disk                = "/dev/sda"
    vm_ip                          = "172.16.1.2"
    vm_kvm_args                    = ""
    vm_mac_address                 = "BC:24:11:FF:FF:02"
    vm_memory_dedicated            = 16384 # 16 GB
    vm_memory_floating             = 16384 # 16 GB
    vm_name                        = "taloswkr"
    vm_on_boot                     = true
    vm_pool_id                     = ""
    vm_started                     = true
    vm_startup_order               = 3
    vm_tags                        = ["k8s", "opentofu", "talos", "worker"]
    vm_timeservers                 = ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"]
    vm_tpm                         = true
  }
}
