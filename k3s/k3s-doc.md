# server
curl -sfL https://get.k3s.io | sh -s - server --disable=traefik --flannel-backend=none --disable-network-policy
cat /var/lib/rancher/k3s/server/node-token
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.14.5 --namespace kube-system --set kubeProxyReplacement=true  --set encryption.enabled=true --set encryption.type=wireguard

# worker
curl -sfL https://get.k3s.io | K3S_URL=https://172.16.241.10:6443 K3S_TOKEN=K10a89fb0a96393f654437c781f1fe4a0f2b2e517774c107cbe3f3b925731620819::server:cc7171c9dafc7aabd608cd3b88336118 sh -
