# dry run

```bash
kubectl kustomize overlays/dev

kubectl kustomize overlays/prod
```

# Run
```bash

# To apply the kustomization
kubectl create namespace app-dev
kubectl apply -k overlays/dev

kubectl create namespace app-prod
kubectl apply -k overlays/prod

```
# Clean up
```bash
kubectl delete -k overlays/prod
kubectl delete -k overlays/dev
kubectl delete namespace app-dev
kubectl delete namespace app-prod
```

# Other
many other example can be found here:
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
