You can try Openshift using the sandbox environment at [https://developers.redhat.com/developer-sandbox](https://developers.redhat.com/developer-sandbox).

to run the demo, you can use the following commands:

```bash
#for sandox you have already a project created for you, otherwise `oc new-project demo`
# you can use `oc` or `kubectl` commands
kubectl apply -f 0.cm.yaml
kubectl apply -f 1.deployment.yaml 
kubectl apply -f 2.service.yaml 
kubectl apply -f 3.route.yam
```
