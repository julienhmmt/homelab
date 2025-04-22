# Gateway-API avec Helm

Pour Cilium 1.17.2, Talos 1.9.4 et Kubernetes 1.31.6, la version de Gateway-API à utiliser est la `1.2.0`.

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f gateway.networking.k8s.io_gatewayclasses.yaml

curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f gateway.networking.k8s.io_gateways.yaml

curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f gateway.networking.k8s.io_httproutes.yaml

curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f gateway.networking.k8s.io_referencegrants.yaml

curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f gateway.networking.k8s.io_grpcroutes.yaml

curl -O https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
kubectl apply -f gateway.networking.k8s.io_tlsroutes.yaml
```
