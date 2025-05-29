```powershell
$NS = "deployment-tutorial"
kubectl create namespace $NS

kubectl apply -n $NS -f .\1-simple-deployment.yaml

kubectl get deploy -n $NS
kubectl describe deploy -n $NS nginx-deployment

kubectl get rs -n $NS
kubectl get pods -n $NS

#change deployment replicas
kubectl scale -n $NS deployment/nginx-deployment --replicas=3
kubectl get pods -n $NS --show-labels -w

#change deployment image
#kubectl set image -n $NS deployment/nginx-deployment nginx=nginx:1.19.0

#change deployment image with rolling update
#kubectl set image -n $NS deployment/nginx-deployment nginx=nginx:1.19.0 --record

kubectl rollout status -n $NS deployment/nginx-deployment

# get the rollout history
kubectl rollout history -n $NS deployment/nginx-deployment

# rollback to a specific version
kubectl rollout undo -n $NS deployment/nginx-deployment --to-revision=1

```

```powershell
kubectl apply -n $NS -f .\2-blue-deployment.yaml

kubectl apply -n $NS -f .\3-green-deployment.yaml

kubectl get pods -n $NS --show-labels -w
```

```
kubectl delete ns $NS
```