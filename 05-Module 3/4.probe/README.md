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

```

```bash
kubectl delete namespace $NS
```

https://github.com/marcelloraffaele/hello

