# Probe
```bash
#
$NS = "probe-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f 1-deploy.yaml
kubectl apply -n $NS -f 2-service.yaml

#check
kubectl get deploy,pod,svc -n $NS

kubectl port-forward -n $NS service/frontend-service 8080:8080

# http://127.0.0.1:8080/docs
# use the client.http file in this folder to test with http


# run contiuous check
while($true) {
    kubectl get deploy -n $NS
#    kubectl get pod -n $NS
    Write-Host "ctrl+c to stop"
    Start-Sleep -Seconds 5
}

```



```bash
kubectl delete namespace $NS
```

https://github.com/marcelloraffaele/hello

