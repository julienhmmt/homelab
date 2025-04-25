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
        kubelet = {
          nodeIP = {
            validSubnets = ["192.168.1.0/24"]
          }
        }
        nodeLabels = {
          "topology.kubernetes.io/region" = var.talos_pve_server
          "topology.kubernetes.io/zone"   = var.talos_pve_server
        }
        features = {
          hostDNS = {
            enabled              = true
            forwardKubeDNSToHost = false
            resolveMemberNames   = true
          }
        }
        network = {
          hostname    = each.value.vm_name
          nameservers = each.value.vm_dns
          interfaces = [
            {
              addresses = ["${each.value.vm_ip}/24"]
              dhcp      = false
              interface = "eth0"
              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = each.value.vm_gateway
                }
              ]
            }
          ]
        }
        install = {
          disk = each.value.vm_install_disk
        }
        time = {
          servers = each.value.vm_timeservers
        }
      }
      cluster = {
        etcd = {
          advertisedSubnets = ["192.168.1.0/24"]
        }
        discovery = {
          enabled = false
          registries = {
            service = {
              disabled = true
            }
          }
        }
        network = {
          cni = { # Cilium will replace it
            name = "custom"
            urls = [
              "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium-custom.yaml"
            ]
          }
        }
        proxy = { # Cilium will replace it
          disabled = true
        }
        allowSchedulingOnControlPlanes = false
        extraManifests = [
          # Gateway API
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml",
          "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml",
          # Cilium
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium-gapi.yaml",
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium-l2announcement.yaml",
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium-lbip-internal.yaml",
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/00-cilium/00-cilium-lbip-external.yaml",
          # Cert Manager
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/01-cert-manager/01-cert-manager-custom.yaml",
          # ArgoCD
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/02-argocd/02-argocd-ns.yaml",
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/02-argocd/02-argocd-install.yaml",
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/02-argocd/02-argocd-httproute.yaml",
          # Monitoring
          "https://raw.githubusercontent.com/julienhmmt/homelab/refs/heads/main/kubernetes/04-monitoring/01-monitoring-ns.yaml"
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
        nodeLabels = {
          "topology.kubernetes.io/region" = var.talos_pve_server
          "topology.kubernetes.io/zone"   = var.talos_pve_server
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
