More info at https://www.cncf.io/wp-content/uploads/2020/08/CNCF-Presentation-Template-K8s-Deployment.pdf

```powershell
$NS = "canary-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\hello-deploy-v1.yaml
kubectl apply -n $NS -f .\production-svc.yaml

kubectl get service,deployment,pod -n $NS

# deploy the v2
kubectl apply -n $NS -f .\hello-deploy-v2.yaml

kubectl get service,deployment,pod -n $NS --show-labels

# switch the service to green
kubectl apply -n $NS -f .\production-svc-green.yaml

# portforwarding
kubectl port-forward -n $NS svc/frontend-service 8080:80


# change the replica count to 1
kubectl scale -n $NS deployment hello-deploy-v2 --replicas=5
kubectl scale -n $NS deployment hello-deploy-v1 --replicas=0
```

```powershell
$url="http://<IP>:8080/api/version"
while ($true) {
    try {
        $response = Invoke-RestMethod -Uri $url
        Write-Host "Version: $($response)"
    }
    catch {
        Write-Host "Error making web request: $($_.Exception.Message)"
    }
    # Add a delay to avoid overwhelming the server
    Start-Sleep -Seconds 1 
}
```

```
kubectl delete ns $NS
```