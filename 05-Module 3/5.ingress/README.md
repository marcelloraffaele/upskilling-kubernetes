# Ingress Controller

enable AKS app routing
```bash
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
az aks approuting enable --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME
```

```bash
#
$NS = "ingress-upskilling"
kubectl create namespace $NS

kubectl get ingressclass

kubectl apply -n $NS -f 1-deploy.yaml
kubectl apply -n $NS -f 2-service.yaml
kubectl apply -n $NS -f 3-ingress.yaml

#check
kubectl get deploy,pod,svc,ingress -n $NS

kubectl port-forward -n $NS svc/frontend-service 8080:8080
```

```bash
kubectl delete namespace $NS

#az aks approuting disable --name <ClusterName> --resource-group <ResourceGroupName>
```
