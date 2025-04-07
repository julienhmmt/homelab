# Cilium with helm

```bash
helm repo add cilium https://helm.cilium.io
helm repo update

helm template cilium --create-namespace \
    cilium/cilium \
    --version 1.17.2 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set envoy.enabled=false \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445 \
    --set k8sClientRateLimit.qps=5 \
    --set k8sClientRateLimit.burst=10 \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
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
    --set bpf.hostLegacyRouting=true \
    --set l2announcement.enabled=true > 00-cilium.custom.yaml
