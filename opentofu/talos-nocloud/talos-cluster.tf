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
        time = {
          servers = ["fr.pool.ntp.org", "time.cloudflare.com"]
        }
        nodeLabels = {
          "topology.kubernetes.io/usage" = each.value.node_usage
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
  depends_on = [
    talos_machine_secrets.this,
    proxmox_virtual_environment_vm.talos_vm
  ]
  for_each = var.nodes
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
        time = {
          servers = ["fr.pool.ntp.org", "time.cloudflare.com"]
        }
        nodeLabels = {
          "topology.kubernetes.io/usage" = each.value.node_usage
        }
      }
      cluster = each.value.role == "controlplane" ? {
        network = {
          dnsDomain = var.kubernetes_dns_domain
          cni = { # Cilium will replace it
            name = "none"
          }
        }
        proxy = { # Cilium will replace it
          disabled = true
        }
        allowSchedulingOnControlPlanes = false
        extraManifests = [
          "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml",
          "https://github.com/cert-manager/cert-manager/releases/download/v1.16.3/cert-manager.yaml",
          "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml",
          "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml"
        ]
      } : null
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  # node                 = [for _, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
  node = element([for _, v in var.nodes : v.vm_ip if v.role == "controlplane"], 0)
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for _, v in var.nodes : v.vm_ip if v.role == "controlplane"][0]
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
