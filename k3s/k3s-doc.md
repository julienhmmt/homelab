# masternode1

```bash
# installation
export INSTALL_K3S_EXEC="server --disable=traefik --flannel-backend=none --disable-network-policy --cluster-init --write-kubeconfig-mode=644"
export K3s_VERSION="v1.29.0+k3s1"

curl -sfL https://get.k3s.io | \
INSTALL_K3S_VERSION=${K3s_VERSION} \
INSTALL_K3S_EXEC=${INSTALL_K3S_EXEC} \
sh -s -

# node token
sudo cat /var/lib/rancher/k3s/server/node-token
```

helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.14.5 --namespace kube-system --set kubeProxyReplacement=true  --set encryption.enabled=true --set encryption.type=wireguard

# masternode2 & masternode3

```bash
export INSTALL_K3S_EXEC="server --disable=traefik --flannel-backend=none --disable-network-policy"
export FIRST_SERVER_IP="172.16.241.10"
export NODE_TOKEN="K1050f75ba16773d4bb086042fc44d6a290049d6cd54aac5de351d9d0001c608b52::server:f9809b4e0cda428c9495b5f03472f4f9"
export K3s_VERSION="v1.29.0+k3s1"

curl -sfL https://get.k3s.io | \
INSTALL_K3S_VERSION=${K3s_VERSION} \
K3S_URL=https://${FIRST_SERVER_IP}:6443 \
K3S_TOKEN=${NODE_TOKEN} \
K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC=${INSTALL_K3S_EXEC} \
sh -
```
