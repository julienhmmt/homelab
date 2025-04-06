# ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm template argocd argo/argo-cd --namespace argocd --create-namespace --version 7.8.23 -f 02-argocd-values.yaml > 02-argocd-install.yaml
```

Le namespace ne semble pas se créer lors du déploiement de l'application. Il faut soit le créer à la main (`kubectl create ns argocd`) sinon copier le contenu du fichier '02-argocd-ns.yaml' au début du fichier '02-argocd-install.yaml'.
