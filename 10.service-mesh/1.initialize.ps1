$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

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


# Explicit versioning matching the control plane revision (ex: istio.io/rev=asm-1-24) is required.
# The default istio-injection=enabled label will not work and will cause the sidecar injection to skip the namespace for the add-on.
# check the revision installed
az aks show --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_NAME}  --query 'serviceMeshProfile.istio.revisions'
#[  "asm-1-26" ]
# annotate the default namespace for automatic sidecar injection
kubectl label namespace default istio.io/rev=asm-1-26
kubectl label namespace default istio-injection=enabled --overwrite

# trigger sidecar injection in default namespace
#kubectl rollout restart -n <namespace> <deployment name>

# to check if sidecar is injected
#kubectl describe pod -n namespace <pod name>

#
#
#
# enable istio ingress gateway
az aks mesh enable-ingress-gateway --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --ingress-gateway-type external

kubectl get svc aks-istio-ingressgateway-external -n aks-istio-ingress
