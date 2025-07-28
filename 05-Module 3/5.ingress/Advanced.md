
```bash
$ING_NS = "app-routing-system"
kubectl get pod,deploy,svc,cm,secret -n $ING_NS
```

we notice that the ingress controller is running, the deployment have 2 replicas and the servce have an external ip. The external ip is the one we will use to access the application.

when a new `Ingress` is created, the ingress controller will automatically Update the configuration inside the ingress controller pods.
We can inspect the logs but also the current configuration of the ingress controller by running:
```bash
kubectl logs -n $ING_NS -l app=nginx
kubectl exec -n $ING_NS -it $(kubectl get pod -n $ING_NS -l app=nginx -o jsonpath='{.items[0].metadata.name}') -- cat /etc/nginx/nginx.conf > before.yaml

##############
$NS = "ingress-tmp"
kubectl create namespace $NS
kubectl apply -n $NS -f 1-deploy.yaml
kubectl apply -n $NS -f 2-service.yaml
kubectl apply -n $NS -f 3-ingress.yaml
##################

kubectl exec -n $ING_NS -it $(kubectl get pod -n $ING_NS -l app=nginx -o jsonpath='{.items[0].metadata.name}') -- cat /etc/nginx/nginx.conf > after.yaml


kubectl delete namespace $NS
``` 