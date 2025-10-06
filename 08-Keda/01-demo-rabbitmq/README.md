# run demo

```bash
$NS="demo1-rabbitmq"
kubectl create ns $NS

kubectl apply -f rabbit-cm.yaml -n $NS
kubectl apply -f rabbit-dep.yaml -n $NS
kubectl apply -f rabbit-svc.yaml -n $NS
kubectl apply -f queue-processor.yaml -n $NS

#in a new terminal
kubectl port-forward svc/rabbit-svc 15672 -n $NS
#go to http://localhost:15672
# login with guest/guest

# load 500 items into the queue
kubectl apply -f queue-loader-job.yaml -n $NS

kubectl apply -f keda-rabbit.yaml -n $NS
# Observer increase in pod replicas.  Show HPA Info (i) panel.  Observe Scale Down Stabilization Window"
kubectl get hpa -n $NS -w

# cleanup
kubectl delete ns $NS
```
