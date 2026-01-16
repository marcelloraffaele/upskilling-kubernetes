
$ING_NS = "app-routing-system"
kubectl get pod,deploy,svc,cm,secret -n $ING_NS

kubectl logs -n $ING_NS -l app=nginx
kubectl exec -n $ING_NS -it $(kubectl get pod -n $ING_NS -l app=nginx -o jsonpath='{.items[0].metadata.name}') -- cat /etc/nginx/nginx.conf > before.yaml

##############
$NS = "helloapp"
kubectl create namespace $NS
kubectl apply -n $NS -f 1-deploy.yaml
kubectl apply -n $NS -f 2-service.yaml
kubectl apply -n $NS -f 3-ingress.yaml

kubectl get ing -n $NS
##################

# from wsl
ingress2gateway print -h

ingress2gateway print --input-file 3-ingress.yaml
ingress2gateway print --input-file 3-ingress.yaml --providers nginx > migration-to-gateway-api.yaml


# test
kubectl delete -n $NS -f 3-ingress.yaml
kubectl apply -n $NS -f 4.gateway-api.yaml

kubectl get httproute -n $NS

kubectl delete -n $NS -f 4.gateway-api.yaml


kubectl delete namespace $NS
