# Getting the kubeconfig and talosconfig can be done with "terraform output -raw kubeconfig > $HOME/.kube/config" 
# and "terraform output -raw talosconfig > $HOME/.talos/config"".
# source : https://github.com/siderolabs/contrib/tree/main/examples/terraform/basic
# source 2 : https://github.com/vehagn/homelab/blob/main/tofu/kubernetes/talos/config.tf

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "this" {
  for_each = var.nodes

  cluster_endpoint   = "https://${var.talos_cluster_endpoint}:6443"
  cluster_name       = var.talos_cluster_name
  kubernetes_version = var.kubernetes_version
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = each.value.role
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
        nodeLabels = {
          "topology.kubernetes.io/usage"  = each.value.node_usage
          "topology.kubernetes.io/region" = var.talos_cluster_name
          "topology.kubernetes.io/zone"   = each.value.vm_name
        }
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.talos_cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.nodes : v.vm_ip if v.role == "controlplane"]
  nodes                = [for k, v in var.nodes : v.vm_ip]
}

resource "talos_machine_configuration_apply" "this" {
  depends_on = [proxmox_virtual_environment_vm.talos_vm]
  for_each   = var.nodes
  lifecycle { # re-run config apply if vm changes
    replace_triggered_by = [proxmox_virtual_environment_vm.talos_vm[each.key]]
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.vm_ip

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.value.vm_name
        }
        install = {
          disk = each.value.vm_install_disk
        }
        nodeLabels = {
          "topology.kubernetes.io/usage"  = each.value.node_usage
          "topology.kubernetes.io/region" = var.talos_cluster_name
          "topology.kubernetes.io/zone"   = each.value.vm_name
        }
      }
      cluster = each.value.role == "controlplane" ? {
        allowSchedulingOnControlPlanes = false
        network = {
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
        extraManifests = [
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/experimental/gateway.networking.k8s.io_gateways.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml"
        ]
      } : null
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for _, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for _, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
}
