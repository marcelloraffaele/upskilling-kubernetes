```powershell
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$LOCATION="italynorth"
$AKS_NAME="upskilling-aks"


$CLIENT_ID=$(az aks show --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --query identity.principalId --output tsv)


az aks show --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --query identity.type --output tsv

```sh
# Get the current user info from the Kubernetes cluster
kubectl config view --minify -o jsonpath='{.users[0].user}'

# Get the current context's user
kubectl config current-context

kubectl get ds -n kube-system -l k8s-app=azure-cni