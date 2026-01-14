$AKS_RESOURCE_GROUP="nap-demo-rg"
$AKS_NAME="nap-demo-aks"

az aks get-credentials --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP

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
# first reset limits to 0 for all nodepools (default and system-surge)
#kubectl patch nodepool default -n default --type merge -p '{"spec":{"limits":{"cpu":"0"}}}'
#kubectl patch nodepool system-surge -n default --type merge -p '{"spec":{"limits":{"cpu":"0"}}}'
#then run the command below to set the node provisioning mode back to Manual
#az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --node-provisioning-mode Manual