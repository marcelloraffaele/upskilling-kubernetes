# Sidecar
```bash
#
$NS = "sidecar-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f 1.sidecar.yaml

#check
kubectl get deploy,pod,svc -n $NS


$POD_NAME=$(kubectl get pods -n $NS -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD_NAME -n $NS

#inspect the logs of the `sidecar-container`
kubectl logs -n $NS $POD_NAME -c sidecar-container
kubectl exec -n $NS -c sidecar-container --stdin --tty $POD_NAME -- /bin/sh
kubectl exec -n $NS -it pod/$POD_NAME -c sidecar-container -- cat /var/log/nginx/access.log


kubectl port-forward -n $NS service/frontend 8080:80

```

# init container

```bash
kubectl apply -n $NS -f 2.init-container.yaml

#check
kubectl get deploy,pod,svc -n $NS
kubectl port-forward -n $NS service/frontend-with-init 8080:80
```

```bash
kubectl delete namespace $NS
```

Other axamples at: https://dev.to/cheedge_lee/sidecar-container-simplified-examples-1m4a