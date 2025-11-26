# Ingress Controller

enable AKS app routing
```bash
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
# only if not executed alreasy az aks approuting enable --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME
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

check the ingress controller pod configuration
```bash
kubectl get pod -n app-routing-system
kubectl exec -it -n app-routing-system nginx-67998d65d7-jtr82 -- bash
cat /etc/nginx/nginx.conf
```


```bash
kubectl delete namespace $NS

#az aks approuting disable --name <ClusterName> --resource-group <ResourceGroupName>
```
