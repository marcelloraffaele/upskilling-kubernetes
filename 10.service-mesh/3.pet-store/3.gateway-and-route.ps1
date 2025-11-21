$NS="pets"
kubectl apply -n $NS -f gateway.yaml
kubectl apply -f pets-route.yaml -n pets


$INGRESS_HOST_EXTERNAL = kubectl -n aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
$INGRESS_PORT_EXTERNAL = kubectl -n aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.spec.ports[?(@.name=="http2")].port}'
$GATEWAY_URL_EXTERNAL = "${INGRESS_HOST_EXTERNAL}:${INGRESS_PORT_EXTERNAL}"

Write-Host "Gateway URL (External): http://${GATEWAY_URL_EXTERNAL}/petstore"
