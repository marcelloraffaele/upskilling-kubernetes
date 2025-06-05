You can try Openshift using the sandbox environment at [https://developers.redhat.com/developer-sandbox](https://developers.redhat.com/developer-sandbox).

to run the demo, you can use the following commands:

```bash
#for sandox you have already a project created for you, otherwise `oc new-project demo`
# you can use `oc` or `kubectl` commands
oc apply -f 0.cm.yaml
oc apply -f 1.deployment.yaml 
oc apply -f 2.service.yaml 
oc apply -f 3.route.yam
```

to delete 
```bash
oc delete -f 0.cm.yaml
oc delete -f 1.deployment.yaml
oc delete -f 2.service.yaml
oc delete -f 3.route.yaml
oc delete -f 4.ingress.yaml
```
