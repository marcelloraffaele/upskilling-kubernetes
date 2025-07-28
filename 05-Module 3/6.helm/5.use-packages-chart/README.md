# Dry run
```bash
$NS = "note-app"
kubectl create namespace $NS
helm install note-app basicapprepo/basic-app-chart --namespace $NS --values ./values.yaml --dry-run


helm install note-app basicapprepo/basic-app-chart --namespace $NS --values ./values.yaml
```

# Test

http://note-app-be.local/swagger-ui/index.html
http://note-app-fe.local
