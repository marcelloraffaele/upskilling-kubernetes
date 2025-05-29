```powershell
$NS = "services-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1-deploy.yaml 

kubectl apply -n $NS -f .\2-service-ClusterIP.yaml  

kubectl apply -n $NS -f .\3-service-LoadBalancer.yaml  

kubectl get service,deployment,pod -n $NS

# portforwarding
kubectl port-forward -n $NS svc/frontend-service 8080:80
```


```
kubectl delete ns $NS
```