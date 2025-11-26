# Sidecar
```bash
#
$NS = "daemonset-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f 1.daemonset.yaml

#check
kubectl get deploy,pod,svc,daemonset -n $NS

```

```bash
kubectl delete namespace $NS
```

Other axamples at: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/