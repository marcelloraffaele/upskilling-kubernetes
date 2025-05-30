# Helm
```bash
$NS = "helm-upskilling"
kubectl create namespace $NS
```

## Install a ready to use chart
```bash
helm search repo wordpress

#default
helm install my-wordpress stable/wordpress --namespace $NS

# can personalize with values
helm show values stable/wordpress
helm show values stable/wordpress > wordpress-values.yaml
helm upgrade my-wordpress stable/wordpress --namespace $NS -f wordpress-values.yaml

kubectl get all -n $NS
```
## Uninstall a chart
```bash
helm uninstall my-wordpress --namespace $NS
```


## Create your own chart
```bash
helm create hello-chart

helm show values ./hello-chart
helm install myhello ./hello-chart --namespace $NS -f hello-values.yaml
helm upgrade myhello ./hello-chart --namespace $NS -f hello-values-blue.yaml
helm upgrade myhello ./hello-chart --namespace $NS -f hello-values-green.yaml

# info about the helm in this namespace
helm list -n $NS

# info about the history of the helm release
helm history myhello --namespace $NS

helm rollback myhello 1 --namespace $NS

helm uninstall myhello --namespace $NS
```

## Destroy the namespace
```bash
kubectl delete namespace $NS
```