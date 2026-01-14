$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$LOCATION="italynorth"
$AKS_NAME="upskilling-aks"
$NODE_COUNT="2"

# Get the nodepool’s metadata including existing scale count. 
az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query agentPoolProfiles


$nodePoolName = (az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query "agentPoolProfiles[0].name" -o tsv)
$nodePoolName

# Scale to 5. Run the above command afterwards to verify outcome. 
az aks scale --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --node-count 5 --nodepool-name $nodePoolName