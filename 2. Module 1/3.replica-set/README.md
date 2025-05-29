```powershell
$NS = "rs-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1.simple-rs.yaml

kubectl get rs -n $NS
kubectl describe rs -n $NS nginx-replicaset
kubectl get pods -n $NS
```

```
kubectl delete ns $NS
```