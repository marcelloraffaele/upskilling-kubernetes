$AKS_RESOURCE_GROUP="upskilling-k8s-private-rg"
$LOCATION="italynorth"

az aks stop --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

az group delete --location $LOCATION `
    --name $AKS_RESOURCE_GROUP `
    --yes `
    --no-wait
