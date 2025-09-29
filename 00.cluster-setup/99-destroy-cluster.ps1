$AKS_RESOURCE_GROUP="upskilling-k8s-rg"

az aks stop --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

az group delete --name $AKS_RESOURCE_GROUP `
    --yes `
    --no-wait