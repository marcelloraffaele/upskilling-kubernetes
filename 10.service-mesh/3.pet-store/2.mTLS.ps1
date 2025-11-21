$NS_OUSIDE="another-ns"
$NS="pets"
kubectl apply -n $NS_OUSIDE -f curl-outside.yaml


CURL_OUTSIDE_POD="$(kubectl get pod -n $NS_OUSIDE -l app=curl -o jsonpath="{.items[0].metadata.name}")"
kubectl exec -it ${CURL_OUTSIDE_POD} -- curl -IL store-front.pets.svc.cluster.local:80


kubectl apply -n $NS -f peer-authentication.yaml


kubectl exec -it ${CURL_OUTSIDE_POD} -n $NS_OUSIDE -- curl -IL store-front.pets.svc.cluster.local:80