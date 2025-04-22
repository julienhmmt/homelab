# Cilium with helm

```bash
helm repo add cilium https://helm.cilium.io
helm repo update

helm template cilium \
    cilium/cilium \
    --version 1.17.2 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set envoy.enabled=true \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445 \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set gatewayAPI.enabled=true \
    --set gatewayAPI.enableAlpn=true \
    --set gatewayAPI.enableAppProtocol=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set metrics.enabled="{dns,drop,tcp,flow,http}" \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set bpf.hostLegacyRouting=true \
    --set bpf.masquerade=true \
    --set bpf.monitorAggregation=medium \
    --set l2announcements.enabled=true \
    --set externalIPs.enabled=true > 00-cilium-custom.yaml
```
