# Cert-manager with helm

```bash
helm repo add jetstack https://charts.jetstack.io --force-update 
helm repo update
helm template \
  cert-manager jetstack/cert-manager \
  -f values.yaml \
  --namespace cert-manager \
  --version v1.17.1 \
  --set crds.enabled=true \
  --set prometheus.enabled=true > ./01-cert-manager.custom.yaml
```