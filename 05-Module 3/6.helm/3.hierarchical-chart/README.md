```powershell
cd .\2.hierarchical-chart\
helm create fe-be-app

cd fe-be-app
Remove-Item -Recurse -Force .\templates
cd charts

helm create frontend
helm create backend
```

# Dry run
```bash
$NS = "note-app"
kubectl create namespace $NS
helm install note-app ./fe-be-app --namespace $NS --dry-run
```

# Run
```bash
$NS = "note-app"
kubectl create namespace $NS
helm install note-app ./fe-be-app --namespace $NS

helm upgrade note-app ./fe-be-app --namespace $NS
```

# Clean up
```bash
$NS = "note-app"
helm uninstall note-app --namespace $NS
kubectl delete namespace $NS
```

# Test

http://note-app-be.local/swagger-ui/index.html
http://note-app-fe.local

# helm test
```bash
 helm test note-app --namespace $NS --logs --timeout 5m
 ```