$NS = "karpenter-demo3"
kubectl create namespace $NS
kubectl apply -f deployment.yaml -n $NS
kubectl apply -f deployment2.yaml -n $NS

kubectl apply -f nodepool-1.yaml
kubectl apply -f nodepool-2.yaml


kubectl scale deployment -n $NS inflate --replicas 3

kubectl get deployment -n $NS

kubectl get nodepool
kubectl get nodeclaims
kubectl get nodes -l aks-karpenter=demo

kubectl get events -A --field-selector source=karpenter -w


kubectl scale deployment -n $NS inflate --replicas 8

kubectl scale deployment -n $NS inflate --replicas 1

#### Cleanup
kubectl delete deployment -n $NS inflate
kubectl delete deployment -n $NS inflate2
kubectl delete -f .\nodepool-2.yaml
kubectl delete -f .\nodepool-1.yaml
kubectl delete namespace $NS