data "talos_machine_disks" "vm_controller" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = "192.168.1.200"
  filters = {
    size = "> 24GB"
    type = "nvme"
  }
}

data "talos_machine_disks" "vm_worker_ram" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = "192.168.1.201"
  filters = {
    size = "> 48GB"
    type = "nvme"
  }
}

data "talos_machine_disks" "vm_worker_viper" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = "192.168.1.202"
  filters = {
    size = "> 96GB"
    type = "nvme"
  }
}

output "nvme_disks" {
  value = data.talos_machine_disks.vm_controller.disks.*.name
}