# namespace creation
```powershell
$NS="hello-world-ns"
kubectl create namespace $NS
```

# Simple deployment
```powershell
kubectl apply -f deployment.yml -n $NS
```

Test the deployment by check:
```powershell
kubectl get pods -n $NS

$POD_NAME=$(kubectl get pods -n $NS -o jsonpath='{.items[0].metadata.name}')
Write-Host "Pod Name: $POD_NAME"
kubectl logs -n $NS $POD_NAME

kubectl port-forward -n $NS $POD_NAME 8080:80
```

# Custom deployment
```powershell
kubectl apply -f deployment-custom.yml -n $NS

# Watch the status of the pods in real-time
kubectl get pods -n $NS --watch

$POD_NAME=$(kubectl get pods -n $NS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NS $POD_NAME 8080:80
```

# Cleanup
```powershell
kubectl delete namespace $NS
```