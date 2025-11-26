# Helm
```bash
$NS = "helm-upskilling"
kubectl create namespace $NS
```

## Install a ready to use chart
```bash
helm search repo mysql
helm search repo redis
helm search repo wordpress

#default


# can personalize with values
helm show values bitnami/wordpress > wordpress-values.yaml
helm install my-wordpress bitnami/wordpress --namespace $NS -f wordpress-values.yaml
helm upgrade my-wordpress bitnami/wordpress --namespace $NS -f wordpress-values.yaml

kubectl get all -n $NS
```
## Uninstall a chart
```bash
helm uninstall my-wordpress --namespace $NS
```

## dry run
```bash
helm install myhello ./hello-chart --namespace $NS --dry-run

helm install myhello ./hello-chart --namespace $NS -f hello-values.yaml --dry-run


```

## Create your own chart
```bash
helm create hello-chart

helm show values ./hello-chart > hello-demo-values.yaml
helm install myhello ./hello-chart --namespace $NS -f hello-values.yaml
helm upgrade myhello ./hello-chart --namespace $NS -f hello-values-blue.yaml #--dry-run > blue-value-dryrun.yaml
helm upgrade myhello ./hello-chart --namespace $NS -f hello-values-green.yaml #--dry-run > green-value-dryrun.yaml

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