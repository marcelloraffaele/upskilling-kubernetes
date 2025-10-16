$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

# enable karpenter in an existing cluster
az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --node-provisioning-mode Auto


#check that karpenter is enabled
az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query "nodeProvisioningProfile.mode"


# get nodepools
kubectl get NodePool -A
kubectl get AKSNodeClass -A


kubectl get NodePool default -n default -o yaml > export/default-nodepool.yaml
kubectl get NodePool system-surge -n default -o yaml > export/system-surge-nodepool.yaml

# to disable karpenter
#az aks update --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --disable-karpenter