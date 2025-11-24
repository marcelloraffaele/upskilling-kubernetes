kubectl apply -f kiali.yaml


kubectl port-forward svc/kiali 20001:20001 -n aks-istio-system