```bash
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"



az k8s-extension create --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME `
    --cluster-type managedClusters --name argocd --extension-type Microsoft.ArgoCD `
    --auto-upgrade false --release-train preview --version 0.0.7-preview `
    --config deployWithHightAvailability=false `
    --config namespaceInstall=false

```

# To access the ArgoCD UI, first retrieve the initial admin password:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
or
kubectl apply -f .\argocd-ingress.yaml


kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | %{ [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

https://127.0.0.1:8080/
# Username: admin
# Password: <the password you retrieved above>

# example 1
```bash


```