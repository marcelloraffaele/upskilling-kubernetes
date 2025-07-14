# Probe
```bash
#
$NS = "probe-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f 1-deploy.yaml
kubectl apply -n $NS -f 2-service.yaml

#check
kubectl get deploy,pod,svc -n $NS

```

```bash
kubectl delete namespace $NS
```

Other axamples at: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/