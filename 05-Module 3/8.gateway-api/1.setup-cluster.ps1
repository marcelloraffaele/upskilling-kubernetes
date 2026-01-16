$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

##############################
# Install Istio Service Mesh
##############################
# chec istio version for my region
$LOCATION="italynorth"
az aks mesh get-revisions --location $LOCATION -o table

#asm-1-27

# check if some old crd where aready in the cluster
kubectl get crd -A | Select-String "istio.io" | ForEach-Object { ($_ -split '\s+')[0] }
# if so remove them
#kubectl delete crd $(kubectl get crd -A | Select-String "istio.io" | ForEach-Object { ($_ -split '\s+')[0] })


# install Istio addon
az aks mesh enable --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_NAME}

# verify installation
az aks show --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_NAME}  --query 'serviceMeshProfile.mode'

kubectl get pods -n aks-istio-system

##################################
# Install Gateway API CRDs
##################################
#from https://learn.microsoft.com/en-us/azure/aks/managed-gateway-api?tabs=install

# register the feature for your subscription
az feature register --namespace "Microsoft.ContainerService" --name "ManagedGatewayAPIPreview"

# install the Managed Gateway API CRDs on an existing cluster with a supported implementation enabled
az aks update -g $AKS_RESOURCE_GROUP -n $AKS_NAME --enable-gateway-api

# To view the CRDs installed on your cluster
kubectl get crds | Select-String "gateway.networking.k8s.io"

# Verify that the CRDs have the expected annotations and that the bundle version matches the expected Kubernetes version for your cluster.

kubectl get crd gateways.gateway.networking.k8s.io -o yaml
