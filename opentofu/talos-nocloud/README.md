# README

## OpenTofu

```bash
tofu plan -concise -out talosvmplan
tofu apply talosvmplan
tofu output -raw talosconfig > ./.talosconfig
tofu output -raw kubeconfig > ./.kubeconfig
cp ./.talosconfig $HOME/.talos/config
cp ./.kubeconfig $HOME/.kube/config
```

## Configuration manuelle des nodes

« Dodge » est le control plane, il n’aura aucun pod. « Ram » devra avoir les pods « infra » genre Gitea, vault etc. « Viper » est le fourre-tout.

```bash
kubectl taint nodes dodge node-role.kubernetes.io/control-plane=true:NoSchedule
kubectl label nodes dodge topology.kubernetes.io/usage=infra
kubectl label nodes ram topology.kubernetes.io/usage=infra
kubectl label nodes viper topology.kubernetes.io/usage=general
```

## Cert-manager

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.3/cert-manager.yaml
```

## Cilium

```bash
# Suppression de kube-proxy
kubectl -n kube-system delete daemonset kube-proxy
```

# Installation de Cilium via helm, remplacement de kube-proxy

```bash
helm install \
    cilium \
    cilium/cilium \
    --version 1.17.1 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=192.168.1.21 \
    --set k8sServicePort=6443 \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set envoy.enabled=false \
    --set gatewayAPI.enabled=true \
    --set gatewayAPI.enableAlpn=true \
    --set gatewayAPI.enableAppProtocol=true \
    --set hubble.enabled=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set bpf.monitorAggregation=medium \
    --set encryption.nodeEncryption=true
```

```bash
kubectl create namespace cilium-test-1
kubectl label namespace cilium-test-1 pod-security.kubernetes.io/enforce=privileged

cilium connectivity test
```
