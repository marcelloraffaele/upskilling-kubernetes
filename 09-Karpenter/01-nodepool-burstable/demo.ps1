kubectl get nodes

# Check existing Pods, there is no pods for Karpenter

kubectl get pods -A

# Check Karpenter CRDs

kubectl get nodepool

kubectl describe nodepool default

kubectl get AKSNodeClass

kubectl get AKSNodeClass default -n default -o yaml > export/default-aksnodeclass.yaml

# Deploy Karpenter custom Nodepool

kubectl apply -f nodepool-burstable.yaml

kubectl get nodepool

# Deploy sample Nginx deployment to trigger Karpenter autoprovisioning

#kubectl create deployment nginx --image=nginx --replicas=1000
kubectl apply -f deployment.yaml
kubectl scale deployment demo-app --replicas=1


kubectl get deploy -w

kubectl get nodes -l aks-karpenter=burstable

# Watch for new VMs created by Karpenter

kubectl get nodes -w

# Check these VMs in Azure portal

# scaledown the deployment

kubectl scale deployment demo-app --replicas=0

# watch for VMs deletion

kubectl get nodes -w

kubectl get events -A --field-selector source=karpenter -w


#### Cleanup
kubectl delete deployment demo-app
kubectl delete -f .\nodepool-burstable.yaml