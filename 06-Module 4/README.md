# Enable Flux on Azure Kubernetes Service (AKS) using Azure CLI
As in this link: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli

The microsoft.flux extension is installed on the cluster (if it wasn't already installed in a previous GitOps deployment).

run the following commands:

```bash
kubectl get namespaces

kubectl get pods -n flux-system

kubectl get crds

kubectl get fluxconfigs -A
kubectl get gitrepositories -A
kubectl get helmreleases -A
kubectl get kustomizations -A

kubectl get deploy -n nginx
```