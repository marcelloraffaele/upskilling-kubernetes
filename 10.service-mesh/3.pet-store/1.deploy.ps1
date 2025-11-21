# Create the pet store namespace
$NS="pets"
kubectl create ns $NS

# Deploy the pet store components to the pets namespace
kubectl apply -f aks-store-all-in-one.yaml -n $NS

kubectl get all -n $NS

# Label the namespace for Azure Service Mesh injection BEFORE deploying
kubectl label namespace $NS istio.io/rev=asm-1-26 --overwrite

kubectl get namespace $NS -o yaml | Select-String -Pattern "labels:" -Context 0,5

#delete label
#kubectl label namespace $NS istio.io/rev- --overwrite

# trigger sidecar injection by restarting deployments
kubectl rollout restart deployment -n $NS
kubectl rollout restart statefulset -n $NS

kubectl get all -n $NS

kubectl describe po -l app=store-front -n pets

# to check if sidecar is injected
#kubectl describe pod -n $NS order-service-67468f6cb7-zcxkz

# clear
kubectl delete -f aks-store-all-in-one.yaml -n $NS
kubectl delete ns $NS