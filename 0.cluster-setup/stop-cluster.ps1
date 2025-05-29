#
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
az aks stop --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP

#start
#az aks start --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP
