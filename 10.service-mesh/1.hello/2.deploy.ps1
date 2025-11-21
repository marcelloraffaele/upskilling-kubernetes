$NS = "frontend-hello"
kubectl create namespace $NS

# Label the namespace for Azure Service Mesh injection BEFORE deploying
kubectl label namespace $NS istio.io/rev=asm-1-26 --overwrite

kubectl apply -n $NS -f app.yaml

kubectl get all -n $NS

kubectl describe po -l app=frontend -n $NS