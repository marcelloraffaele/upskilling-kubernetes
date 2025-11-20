$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

az aks show --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --query 'serviceMeshProfile' --output json