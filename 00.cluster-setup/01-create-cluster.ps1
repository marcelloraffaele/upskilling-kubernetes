$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$LOCATION="italynorth"
# The minimal VM size recommended for AKS worker nodes is Standard_B2s, which provides 2 vCPUs and 4 GiB RAM;
# For production AKS clusters, the recommended VM sizes is at least 2 vCPUs and 8 GiB RAM, such as Standard_D2s_v3 or Standard_DS2_v2.
# [AKS node size recommendations](https://learn.microsoft.com/en-us/azure/aks/quotas-skus-regions)
$VM_SKU="Standard_B2s"
$AKS_NAME="upskilling-aks"
$NODE_COUNT="2"

az group create --location $LOCATION `
    --resource-group $AKS_RESOURCE_GROUP

az aks create --node-count $NODE_COUNT `
    --generate-ssh-keys `
    --node-vm-size $VM_SKU `
    --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

az aks get-credentials --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

# create an Azure Container Registry (ACR) to store container images
$ACR_NAME="acrupskilling"
az acr create --resource-group $AKS_RESOURCE_GROUP `
    --name $ACR_NAME `
    --sku Basic
#    --enable-oidc-issuer --enable-workload-identity

# attach the ACR to the AKS cluster
az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --attach-acr $ACR_NAME

# enable workload identity
az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --enable-oidc-issuer --enable-workload-identity

# example of importing an image into the ACR
#az acr import --name $ACR_NAME --source docker.io/library/nginx:latest --image nginx:v1

#kubectl config view
#kubectl config get-contexts
#kubectl config get-clusters