$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
$FLUX_CONFIG_NAME="cluster-config"
$NAMESPACE="cluster-config"

kubectl create namespace $NAMESPACE

az k8s-configuration flux create -g $AKS_RESOURCE_GROUP -c $AKS_NAME -n $FLUX_CONFIG_NAME `
    --namespace $NAMESPACE -t managedClusters --scope cluster `
    -u https://github.com/Azure/gitops-flux2-kustomize-helm-mt --branch main `
    --kustomization name=infra path=./infrastructure prune=true `
    --kustomization name=apps path=./apps/staging prune=true dependsOn=["infra"]


# az k8s-configuration flux delete --resource-group $AKS_RESOURCE_GROUP `
#    --cluster-name $AKS_NAME --cluster-type managedClusters --name $FLUX_CONFIG_NAME