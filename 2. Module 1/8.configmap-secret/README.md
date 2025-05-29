# ConfigMap
```powershell
$NS = "cm-and-secret-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1-configmap.yaml
kubectl apply -n $NS -f .\2-deployment.yaml

# get all pods in the namespace and show labels
kubectl get cm,deploy,svc,pods --show-labels -n $NS

# portforwarding
kubectl port-forward -n $NS svc/nginx-service 8080:80
```
# Secret
```powershell
kubectl apply -n $NS -f .\3-secret.yaml
kubectl apply -n $NS -f .\4-deployment.yaml

#access in ssh the pod
kubectl exec -it -n $NS $(kubectl get pods -n $NS -l app=nginx -o jsonpath='{.items[0].metadata.name}') -- /bin/sh

# and check the env variables using `env`
env | grep username
env | grep apiKey
env | grep password
```

```
kubectl delete ns $NS
```