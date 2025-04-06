# Getting the kubeconfig and talosconfig can be done with "terraform output -raw kubeconfig > $HOME/.kube/config" 
# and "terraform output -raw talosconfig > $HOME/.talos/config"".
# source : https://github.com/siderolabs/contrib/tree/main/examples/terraform/basic
# source 2 : https://github.com/vehagn/homelab/blob/main/tofu/kubernetes/talos/config.tf

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  for_each = var.nodes

  cluster_endpoint   = "https://${var.talos_cluster_endpoint}:6443"
  cluster_name       = var.talos_cluster_name
  kubernetes_version = var.kubernetes_version
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "controlplane"
  talos_version      = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.value.vm_name
        }
        install = {
          disk = each.value.vm_install_disk
        }
        time = {
          servers = ["fr.pool.ntp.org", "time.cloudflare.com"]
        }
      }
      cluster = {
        network = {
          dnsDomain = var.kubernetes_dns_domain
          cni = { # Cilium will replace it
            name = "custom"
            urls = [
              "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium.custom.yaml"
            ]
          }
        }
        proxy = { # Cilium will replace it
          disabled = true
        }
        allowSchedulingOnControlPlanes = true
        extraManifests = [
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/01-cert-manager/01-cert-manager.custom.yaml",
          "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml"
        ]
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [data.talos_machine_configuration.controlplane]
  for_each   = { for key, value in var.nodes : key => value if value.role == "controlplane" }
  lifecycle { replace_triggered_by = [proxmox_virtual_environment_vm.talos_vm[each.key]] } # re-run config apply if vm changes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane[each.key].machine_configuration
  node                        = each.value.vm_ip
}

data "talos_machine_configuration" "worker" {
  for_each = var.nodes

  cluster_endpoint   = "https://${var.talos_cluster_endpoint}:6443"
  cluster_name       = var.talos_cluster_name
  kubernetes_version = var.kubernetes_version
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "worker"
  talos_version      = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.value.vm_name
        }
        install = {
          disk = each.value.vm_install_disk
        }
        time = {
          servers = ["fr.pool.ntp.org", "time.cloudflare.com"]
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [data.talos_machine_configuration.worker]
  for_each   = { for key, value in var.nodes : key => value if value.role == "worker" }
  lifecycle { replace_triggered_by = [proxmox_virtual_environment_vm.talos_vm[each.key]] } # re-run config apply if vm changes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  node                        = each.value.vm_ip
}

data "talos_client_configuration" "this" {
  cluster_name         = var.talos_cluster_name
  endpoints            = [for node in var.nodes : node.vm_ip if node.role == "controlplane"]
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_configuration_apply.worker,
    talos_machine_bootstrap.this
  ]
  endpoints              = data.talos_client_configuration.this.endpoints
  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = [for k, v in var.nodes : v.vm_ip if v.role == "controlplane"]
  skip_kubernetes_checks = true
  timeouts = {
    read = "10m"
  }
  worker_nodes = [for k, v in var.nodes : v.vm_ip if v.role == "worker"]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this,
    # data.talos_cluster_health.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.talos_cluster_endpoint
  node                 = [for k, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
  timeouts = {
    read = "1m"
  }
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
