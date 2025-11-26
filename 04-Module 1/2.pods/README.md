```powershell
$NS = "pod-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1.simple-pod.yaml

kubectl get pods -n $NS nginx-pod
kubectl get pods -n $NS nginx-pod -o yaml


kubectl exec -n $NS -it nginx-pod -c nginx -- bash
```

```powershell
kubectl apply -n $NS -f .\2.simple-pod2.yaml
kubectl get pods -n $NS nginx-pod2

kubectl describe pod -n $NS nginx-pod2
kubectl logs -n $NS nginx-pod2 -c nginx
kubectl logs -n $NS nginx-pod2 -c mysql
kubectl logs -n $NS nginx-pod2 -c counter

kubectl delete -n $NS -f .\2.simple-pod2.yaml
```


```
kubectl delete ns $NS
```