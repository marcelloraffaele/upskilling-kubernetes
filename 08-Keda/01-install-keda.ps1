$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

# enable keda
az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --enable-keda


#check that keda is enabled
az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query "workloadAutoScalerProfile.keda.enabled"

kubectl get pods -n kube-system

#check the keda version
kubectl get crd/scaledobjects.keda.sh -o yaml
#and search for the label app.kubernetes.io/version

# to disable keda
#az aks update --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --disable-keda