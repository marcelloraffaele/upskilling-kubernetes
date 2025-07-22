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
$NS = "todo-app"
kubectl create namespace $NS
helm install todo-app ./fe-be-app --namespace $NS --dry-run
```

# Run
```bash
$NS = "todo-app"
kubectl create namespace $NS
helm install todo-app ./fe-be-app --namespace $NS

helm upgrade todo-app ./fe-be-app --namespace $NS
```