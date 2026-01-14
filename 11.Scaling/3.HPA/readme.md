
# HPA demo (AKS)

This demo shows **Horizontal Pod Autoscaler (HPA)** scaling a Deployment based on **CPU utilization**.

It deploys into a dedicated namespace (`hpa-demo`):
- `cpu-demo` Deployment + Service (a small HTTP server)
- `cpu-demo` HPA (scales replicas based on CPU)
- `load-generator` Deployment (optional; generates traffic to raise CPU)

## Prerequisites

- You’re connected to your AKS cluster: `kubectl cluster-info`
- The Metrics API works (required for HPA CPU metrics):
	- `kubectl top nodes`

If `kubectl top ...` fails, check whether metrics are available:
- `kubectl get apiservice v1beta1.metrics.k8s.io`
- `kubectl get deployment metrics-server -n kube-system`

## Deploy

From this folder:

```bash
kubectl apply -f hpa-demo.yaml
kubectl apply -f load-generator.yaml
```

Verify resources:

```bash
kubectl get ns hpa-demo
kubectl get deploy,svc,hpa,pods -n hpa-demo
```

## Generate load (to trigger scaling)

The load generator is created with `replicas: 0` so it does nothing until you enable it.

Start generating traffic:

```bash
kubectl scale deploy/load-generator -n hpa-demo --replicas=1
```

## What to watch / check

Watch the HPA compute desired replicas:

```bash
kubectl get hpa cpu-demo -n hpa-demo -w
```

Watch the Deployment scale out:

```bash
kubectl get deploy cpu-demo -n hpa-demo -w
kubectl get pods -n hpa-demo -l app=cpu-demo -w
```

Inspect HPA details (targets, conditions, events):

```bash
kubectl describe hpa cpu-demo -n hpa-demo
```

Check CPU usage (needs metrics-server):

```bash
kubectl top pods -n hpa-demo
```

Expected behavior:
- At first, `cpu-demo` runs 1 replica.
- After enabling the load generator, CPU rises and HPA increases replicas (up to `maxReplicas: 10`).
- The `TARGETS` column in `kubectl get hpa` should move above/below the configured `50%` threshold.

Note: scaling is not instant—give it ~30–120 seconds to react.

## Stop load and observe scale down

Stop generating traffic:

```bash
kubectl scale deploy/load-generator -n hpa-demo --replicas=0
```

Watch replicas decrease over the next couple minutes:

```bash
kubectl get hpa cpu-demo -n hpa-demo -w
kubectl get deploy cpu-demo -n hpa-demo -w
```

## Cleanup

```bash
kubectl delete namespace hpa-demo
```
