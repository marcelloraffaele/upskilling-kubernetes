$NS="default"
kubectl apply -n $NS -f virtual-service-all-v1.yaml


kubectl get virtualservices -o yaml


kubectl apply -n $NS -f virtual-service-reviews-test-v2.yaml

# cleanup
kubectl delete -n $NS -f virtual-service-all-v1.yaml



#fault injection test
kubectl apply -n $NS -f .\fault-injection.yaml

#traffic shaping
kubectl apply -n $NS -f .\traffic-shaping.yaml