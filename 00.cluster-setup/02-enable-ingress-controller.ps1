$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
# enable application routing for the AKS cluster
az aks approuting enable --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME

# verify the ingress controller service is created
# check that the ingress controller service is running and have a public IP assigned
kubectl get services -n app-routing-system