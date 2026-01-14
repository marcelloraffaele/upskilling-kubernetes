$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$LOCATION="italynorth"
$AKS_NAME="upskilling-aks"
$NODE_COUNT="2"

az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query agentPoolProfiles


$nodePoolName = (az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query "agentPoolProfiles[0].name" -o tsv)
$nodePoolName

# Enable the cluster autoscaler on an existing cluster
az aks update --resource-group myResourceGroup --name myAKSCluster --enable-cluster-autoscaler --min-count 1 --max-count 3
