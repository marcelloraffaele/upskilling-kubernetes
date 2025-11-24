$NS="pets"
kubectl apply -n $NS -f gateway.yaml
kubectl apply -f pets-route.yaml -n pets


$INGRESS_HOST_EXTERNAL = kubectl -n aks-istio-ingress get service aks-istio-ingressgateway-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}'


# if you define in your hosts file "petstore.local" to point to the INGRESS_HOST_EXTERNAL IP, you can use the below curl command
curl -s -H "Host: petstore.local" "http://petstore.local"