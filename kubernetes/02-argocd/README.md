# ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm search repo argo/argo-cd --versions | head -n10
helm template argocd argo/argo-cd --namespace argocd --create-namespace --version 7.8.28 -f 02-argocd-custom-values.yaml > 02-argocd-install.yaml
```

Le namespace ne semble pas se créer lors du déploiement de l'application. Il faut soit le créer à la main (`kubectl create ns argocd`) sinon copier le contenu du fichier '02-argocd-ns.yaml' au début du fichier '02-argocd-install.yaml'.

Si vous spécifiez le mot de passe avec un hash bcrypt2 dans le fichier custom-values.yaml, alors vous le connaissez. Sinon, Le mot de passe du compte 'admin' par défaut se trouve via la commande : `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`.

Pour savoir comment sortir le *jsonpath*, il faut describe le secret. Il y a à la fin de l'énumération un bloc "Data" et une clé "password", c'est à l'intérieur qu'on peut avoir le code en base64 : `kubectl -n argocd get secret argocd-initial-admin-secret`.

<https://artifacthub.io/packages/helm/argo/argo-cd>
