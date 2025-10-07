# Demo
Be sure to enable the Ingress controller in your cluster.
If need to enable it run the `00.cluster-setup/02-enable-ingress-controller.sh` script.

# Initialize Deploy 
```bash
$NS= "keda-http"
kubectl create ns $NS
kubectl apply -f application.yaml -n $NS
kubectl apply -f application-ing.yaml -n $NS

# you can check the application is running
# http://example.local/api/time


kubectl get pods -n $NS
```

# Install HTTP Add-On
```bash
$ADDON_NS= "keda-http-addon"
$ADDON_VERSION= "v0.10.0"
helm install http-add-on kedacore/keda-add-ons-http --namespace $ADDON_NS --create-namespace
#helm install http-add-on kedacore/keda-add-ons-http --create-namespace --namespace $ADDON_NS --set images.tag=$ADDON_VERSION


```

# Install HTTP Scaler
```bash
kubectl apply -f http-scaled-object.yaml -n $NS

kubectl delete -f application-ing.yaml -n $NS

kubectl apply -f .\application-ing-for-scaling.yaml

```


# Cleanup
```bash
kubectl delete -f application-ing-for-scaling.yaml
kubectl delete ns $NS

#cleanup the add-on
helm uninstall http-add-on -n $ADDON_NS
kubectl delete ns $ADDON_NS
```