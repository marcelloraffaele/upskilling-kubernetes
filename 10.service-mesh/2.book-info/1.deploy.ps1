$NS="default"
# install the Bookinfo application
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl get services

kubectl get pods


# setup the istio config forthe namespace
# Explicit versioning matching the control plane revision (ex: istio.io/rev=asm-1-24) is required.
# The default istio-injection=enabled label will not work and will cause the sidecar injection to skip the namespace for the add-on.
# check the revision installed
az aks show --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_NAME}  --query 'serviceMeshProfile.istio.revisions'
#[  "asm-1-26" ]
# annotate the default namespace for automatic sidecar injection
kubectl label namespace default istio.io/rev=asm-1-26

kubectl get namespace $NS -o yaml | Select-String -Pattern "labels:" -Context 0,5

# trigger sidecar injection in default namespace
kubectl rollout restart -n default deployment

# to check if sidecar is injected
#kubectl describe pod -n namespace <pod name>

# clear
#delete label
kubectl label namespace $NS istio.io/rev- --overwrite

kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml
