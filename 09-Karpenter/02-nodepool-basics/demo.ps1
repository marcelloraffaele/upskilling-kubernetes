$NS = "karpenter-demo2"
kubectl create namespace $NS
kubectl apply -f deployment.yaml -n $NS

kubectl apply -f nodepool-basic.yaml


kubectl get nodepool

kubectl scale deployment -n $NS inflate --replicas 5

kubectl get deploy -n $NS

kubectl get nodeclaims
kubectl get nodes -l aks-karpenter=demo

kubectl get events -A --field-selector source=karpenter -w


kubectl scale deployment -n $NS inflate --replicas 8

kubectl scale deployment -n $NS inflate --replicas 1


##########
# deployment 2
kubectl apply -f deployment-2.yaml -n $NS
kubectl scale deployment -n $NS fe-deploy --replicas 5


#### Cleanup
kubectl delete deployment -n $NS inflate
kubectl delete deployment -n $NS fe-deploy
kubectl delete -f .\nodepool-basic.yaml
kubectl delete namespace $NS