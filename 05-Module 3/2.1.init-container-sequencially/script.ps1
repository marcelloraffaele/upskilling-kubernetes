# Init container to sequentially run microservices
#In this example, we will create a Kubernetes Pod that uses an init container to ensure that a database service is fully initialized before starting the main application container. This is useful in scenarios where the application depends on the database being ready to accept connections.


$NS="init-container-sequencially"
kubectl create namespace $NS

kubectl apply -f 1.mysql-deployment.yaml -n $NS
kubectl apply -f 2.app-deployment.yaml -n $NS


while ($true) { 
    kubectl get pods -n $NS;
    Write-Output "CTRL+c to stop monitoring..." 
    Start-Sleep -Seconds 5
    Write-Output ""    
}


Pause

# restart the application to see the init container in action
kubectl rollout restart deployment/myapp -n $NS

Pause 

# clean up
kubectl delete -f 2.app-deployment.yaml -n $NS
kubectl delete -f 1.mysql-deployment.yaml -n $NS
kubectl delete namespace $NS