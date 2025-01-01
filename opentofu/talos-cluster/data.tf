data "talos_machine_configuration" "machineconfig_controller_dodge" {
  cluster_name     = var.talos_cluster_details.name
  talos_version    = var.talos_cluster_details.version
  cluster_endpoint = "https://192.168.1.200:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "machineconfig_controller_dodge" {
  cluster_name         = var.talos_cluster_details.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = ["192.168.1.200"]
}

data "talos_machine_configuration" "machineconfig_worker_ram" {
  cluster_name     = var.talos_cluster_details.name
  talos_version    = var.talos_cluster_details.version
  cluster_endpoint = "https://192.168.1.201:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "machineconfig_worker_ram" {
  cluster_name         = var.talos_cluster_details.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = ["192.168.1.201"]
}

data "talos_machine_configuration" "machineconfig_worker_viper" {
  cluster_name     = var.talos_cluster_details.name
  talos_version    = var.talos_cluster_details.version
  cluster_endpoint = "https://192.168.1.202:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "machineconfig_worker_viper" {
  cluster_name         = var.talos_cluster_details.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = ["192.168.1.202"]
}
