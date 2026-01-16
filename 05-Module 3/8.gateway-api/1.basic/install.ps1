#from https://learn.microsoft.com/en-us/azure/aks/istio-gateway-api

$NS="httpbin-demo"
kubectl create namespace $NS
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/httpbin/httpbin.yaml -n $NS

kubectl apply -f gateway.yaml
kubectl apply -f http-route.yaml -n $NS

kubectl get httproute -n $NS


kubectl get deployment httpbin-gateway-istio
kubectl get service httpbin-gateway-istio
kubectl get hpa httpbin-gateway-istio
kubectl get pdb httpbin-gateway-istio

kubectl wait --for=condition=programmed gateways.gateway.networking.k8s.io httpbin-gateway
$INGRESS_HOST = (kubectl get gateways.gateway.networking.k8s.io httpbin-gateway -o jsonpath='{.status.addresses[0].value}').Trim()

curl -s -I -HHost:httpbin.example.com "http://$INGRESS_HOST/get"

# clean up
kubectl delete -f http-route.yaml -n $NS
kubectl delete -f gateway.yaml
kubectl delete namespace $NS