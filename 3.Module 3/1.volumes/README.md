In this example is created:

- A Secret for password management
- A Config map for initial SQL setup:
  - create user event db
  - create the `event` table
  - insert some example rows in `event` table
- A ReplicaSet for the singleton MySQL database instance that will use the secret and config map
- All the created objects have the `project=mysql-test` label, we can use it to identify the objects and manage it.

```bash
#
$NS = "volume-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f 1.mysql-configmap.yaml
kubectl apply -n $NS -f 2.mysql-secret.yaml
kubectl apply -n $NS -f 3.mysql-pvc.yaml
kubectl apply -n $NS -f 4.mysql-deployment.yaml

#check
kubectl get configmap,secret,deploy,pod,pvc,pv -n $NS

```




Let's inspect the pod from inside:
```bash
$POD_NAME=$(kubectl get pods -n $NS -o jsonpath='{.items[0].metadata.name}')
#inspect the logs
kubectl logs -n $NS $POD_NAME

#access the pod using bash
kubectl exec -n $NS --stdin --tty $POD_NAME -- /bin/bash

#open mysql using root account
mysql -h localhost -u root -p
# write the 'root' password

#otherwise open mysql using root account
mysql -h localhost -u eventdb -p
# write the 'eventdb' password the same as in the secret

```

Now that we have the mysql client running, we can check the database:

```sql
use eventdb;
select * from event;

mysql> delete from event where id=5;
Query OK, 1 row affected (0.02 sec)
mysql> commit;

quit
```

# check if the volume is persistent
```bash
kubectl delete -n $NS pod $POD_NAME
kubectl get pods -n $NS -w
$POD_NAME=$(kubectl get pods -n $NS -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $NS --stdin --tty $POD_NAME -- /bin/bash
```


```bash
# clean up the namespace
# only if you want to delete the created objects
kubectl delete -n $NS -f 4.mysql-deployment.yaml
kubectl delete -n $NS -f 1.mysql-configmap.yaml
kubectl delete -n $NS -f 2.mysql-secret.yaml
kubectl delete -n $NS -f 3.mysql-pvc.yaml

kubectl delete namespace $NS
```