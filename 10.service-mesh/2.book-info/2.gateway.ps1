$NS="default"

kubectl apply -n $NS -f gateway.yaml
kubectl apply -n $NS -f .\virtual-service-base.yaml

$INGRESS_HOST_EXTERNAL = kubectl -n aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
$INGRESS_PORT_EXTERNAL = kubectl -n aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.spec.ports[?(@.name=="http2")].port}'
$GATEWAY_URL_EXTERNAL = "${INGRESS_HOST_EXTERNAL}:${INGRESS_PORT_EXTERNAL}"

Write-Host "Gateway URL (External): http://${GATEWAY_URL_EXTERNAL}/productpage"
#Gateway URL (External): http://9.235.155.62:80/productpage


curl -s "http://${GATEWAY_URL_EXTERNAL}/productpage"


#
kubectl get svc -n $NS


# install destination rules
kubectl apply -n $NS -f destination-rule.yaml


#clear
kubectl delete -n $NS -f destination-rule.yaml
kubectl delete -n $NS -f virtual-service-base.yaml
kubectl delete -n $NS -f gateway.yaml