```powershell
$env:GITHUB_TOKEN = "..."
$env:GITHUB_USER = "..."
```

or in ssh

```bash
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```

install flux
```bash
flux bootstrap github `
  --token-auth `
  --owner=$GITHUB_USER `
  --repository=flux-demo `
  --branch=main `
  --path=./clusters/my-cluster `
  --personal=true `
  --private=true `
  --log-level debug --verbose

```


```bash
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
$FLUX_CONFIG_NAME="flux-demo"
$NAMESPACE="flux-demo"

kubectl create namespace $NAMESPACE

az k8s-configuration flux create `
  -g $AKS_RESOURCE_GROUP -c $AKS_NAME -n $FLUX_CONFIG_NAME `
    --namespace $NAMESPACE -t managedClusters --scope cluster `
  --kind git `
  --url https://github.com/marcelloraffaele/flux-demo.git `
  --https-user $env:GITHUB_USER `
  --https-key $env:GITHUB_TOKEN `
  --branch main `
  --kustomization name=app1 path=./app1/overlays/dev prune=true

az k8s-configuration flux show -g $AKS_RESOURCE_GROUP -c $AKS_NAME -n $FLUX_CONFIG_NAME -t managedClusters

az k8s-configuration flux delete --resource-group $AKS_RESOURCE_GROUP `
    --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME
```



## Check
```bash
kubectl get Kustomization -A
kubectl describe Kustomization flux-demo-app1 -n flux-demo

kubectl get Kustomization flux-demo-app1 -n flux-demo -o yaml
```

## Cluster config
```bash
az k8s-configuration flux kustomization create --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-cluster-config --path ./cluster-config --prune --force

az k8s-configuration flux kustomization delete --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-cluster-config
```


## App 2
```bash
az k8s-configuration flux kustomization create --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-app2 --path ./app2 --prune --force

az k8s-configuration flux kustomization delete --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-app2
  ```

## App 3
```bash
az k8s-configuration flux kustomization create --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-app3 --path ./app3 --prune --force

az k8s-configuration flux kustomization delete --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-app3
  ```

## bootstrap
```bash
az k8s-configuration flux kustomization create --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-bootstrap --path ./bootstrap/flux-system --prune --force

az k8s-configuration flux kustomization delete --resource-group $AKS_RESOURCE_GROUP --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME --kustomization-name flux-demo-bootstrap
  ```
