
# StatefulSet demo (stable identity + per-pod storage)

This demo deploys an NGINX `StatefulSet` with:

- **Stable pod names**: `nginx-0`, `nginx-1`, `nginx-2`
- **Stable DNS** via a **headless Service**: `nginx-0.nginx-headless`, ...
- **Per-pod persistent volumes** created by `volumeClaimTemplates`:
	- `www-nginx-0`, `www-nginx-1`, `www-nginx-2`
- A small **toolbox** pod used to `curl` and `nslookup` services from inside the cluster

## Deploy

```bash
$NS = "statefulset-demo"

kubectl apply -f 1.namespace.yaml
kubectl apply -f 2.services.yaml
kubectl apply -f 3.statefulset.yaml
kubectl apply -f 4.toolbox.yaml

kubectl get all -n $NS
kubectl get statefulset,pod -n $NS
kubectl get pvc -n $NS
```

Wait until pods are ready:

```bash
kubectl get pods -n $NS -w
```

## Verify (what to show)

### 1) Stable identity (names + ordered startup)

```bash
kubectl get pods -n $NS -o wide
kubectl get statefulset -n $NS
```

Point out:

- Pod names are **ordinal** (`nginx-0`, `nginx-1`, `nginx-2`)
- StatefulSet creates pods in order (0 then 1 then 2)

### 2) Stable DNS with a headless service

From the toolbox pod:

```bash
kubectl exec -n $NS -it toolbox -- sh

nslookup nginx-0.nginx-headless
nslookup nginx-1.nginx-headless
nslookup nginx-2.nginx-headless

curl -s nginx-0.nginx-headless | head
curl -s nginx-1.nginx-headless | head
curl -s nginx-2.nginx-headless | head
exit
```

Explain:

- `nginx-headless` doesn’t load balance; it returns **pod IPs** directly
- Each pod has a **stable DNS name** useful for clustered/stateful apps

### 3) Service load-balancing vs per-pod identity

Show that the normal ClusterIP service (`nginx`) load-balances across pods:

```bash
kubectl exec -n $NS toolbox -- sh -c "for i in 1 2 3 4 5; do curl -s nginx | head -n 1; done"
```

You should see different outputs like `Hello from nginx-0`, `Hello from nginx-1`, etc.

### 4) Per-pod persistent storage (PVC per replica)

List PVCs:

```bash
kubectl get pvc -n $NS
```

Write a file into a specific pod’s volume, delete the pod, and show the data is still there:

```bash
kubectl exec -n $NS nginx-1 -- sh -c "echo 'CUSTOM DATA: '$(date) >> /usr/share/nginx/html/index.html"

kubectl exec -n $NS toolbox -- sh -c "curl -s nginx-1.nginx-headless | tail -n 3"

kubectl delete pod -n $NS nginx-1
kubectl get pods -n $NS -w

kubectl exec -n $NS toolbox -- sh -c "curl -s nginx-1.nginx-headless | tail -n 3"
```

Explain:

- The pod is recreated with the **same name** (`nginx-1`)
- It reattaches to the **same PVC** (`www-nginx-1`)
- The content remains, proving storage is **persistent and per-replica**

### 5) Scale down/up without losing volumes

```bash
kubectl scale statefulset -n $NS nginx --replicas=1
kubectl get pods -n $NS -w

kubectl get pvc -n $NS

kubectl scale statefulset -n $NS nginx --replicas=3
kubectl get pods -n $NS -w
```

Explain:

- Scaling down removes pods, but PVCs usually remain
- Scaling back up reuses the same claims (`www-nginx-1`, `www-nginx-2`)

## Suggested customer demo narrative (2–5 minutes)

1. **Problem statement**: some apps need stable identity + stable storage (databases, queues, clustered systems).
2. **StatefulSet gives identities**: deterministic names (`nginx-0..n`) and ordered rollout.
3. **Headless service gives DNS per replica**: connect to a specific pod when needed.
4. **Persistent volumes per replica**: each instance gets its own disk; restart/reschedule doesn’t lose data.
5. **Scaling behavior**: scale down/up without re-provisioning or losing data.

## Cleanup

Delete workload and services:

```bash
kubectl delete -f 4.toolbox.yaml
kubectl delete -f 3.statefulset.yaml
kubectl delete -f 2.services.yaml
```

PVCs are not always deleted automatically. Remove them explicitly:

```bash
$NS = "statefulset-demo"
kubectl delete pvc -n $NS -l app=nginx
```

Finally delete the namespace:

```bash
kubectl delete -f 1.namespace.yaml
```

