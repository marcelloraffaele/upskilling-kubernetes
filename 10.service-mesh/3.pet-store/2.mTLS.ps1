$NS_OUSIDE="another-ns"
$NS="pets"
kubectl create ns $NS_OUSIDE
kubectl apply -n $NS_OUSIDE -f curl-outside.yaml


kubectl get pod -n $NS_OUSIDE -l app=curl -o jsonpath="{.items[0].metadata.name}"
$CURL_OUTSIDE_POD="curl-outside-7c8d4979c6-v4vh2"
kubectl exec -it $CURL_OUTSIDE_POD -n $NS_OUSIDE -- curl -IL store-front.pets.svc.cluster.local:80


kubectl apply -n $NS -f peer-authentication.yaml


kubectl exec -it ${CURL_OUTSIDE_POD} -n $NS_OUSIDE -- curl -IL store-front.pets.svc.cluster.local:80


# ingress
kubectl apply -n $NS -f ingress.yaml


kubectl delete -n $NS -f peer-authentication.yaml