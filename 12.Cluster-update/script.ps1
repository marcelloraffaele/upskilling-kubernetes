$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"



az aks get-upgrades --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --output table


az aks upgrade --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --kubernetes-version <version>



az aks nodepool get-upgrades --nodepool-name <nodepool-name> --cluster-name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP