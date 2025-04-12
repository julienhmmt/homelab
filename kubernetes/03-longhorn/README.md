# Longhorn

Stockage répliqué.

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm search repo longhorn
helm show values longhorn/longhorn > 03-longhorn-values.yaml
helm template longhorn/longhorn --create-namespace --namespace storage -f 03-longhorn-values.yaml > 03-longhorn-install.yaml
```