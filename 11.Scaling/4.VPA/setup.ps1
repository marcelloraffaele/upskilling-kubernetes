
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"

az aks update -n $AKS_NAME -g $AKS_RESOURCE_GROUP --enable-vpa


$NS="vpa-demo"
kubectl create ns $NS
kubectl apply -f .\manifest.yaml -n $NS


kubectl get vpa, deploy,pod -n $NS


kubectl get pod hamster-574c696947-rvwvn -n $NS -o yaml

kubectl delete ns $NS