```powershell
$NS = "labels-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1-simple-deployment.yaml

# get all pods in the namespace and show labels
kubectl get pods --show-labels -n $NS

# get pods with specific label
kubectl get pods -n $NS --selector=env=dev
```


```
kubectl delete ns $NS
```