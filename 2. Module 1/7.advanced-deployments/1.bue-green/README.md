More info at https://www.cncf.io/wp-content/uploads/2020/08/CNCF-Presentation-Template-K8s-Deployment.pdf

```powershell
$NS = "blue-green-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\blue-deploy.yaml
kubectl apply -n $NS -f .\production-svc-blue.yaml

kubectl get service,deployment,pod -n $NS

# deploy the green version
kubectl apply -n $NS -f .\green-deploy.yaml

kubectl get service,deployment,pod -n $NS --show-labels

# switch the service to green
kubectl apply -n $NS -f .\production-svc-green.yaml

# portforwarding
kubectl port-forward -n $NS svc/frontend-service 8080:80
```


```
kubectl delete ns $NS
```