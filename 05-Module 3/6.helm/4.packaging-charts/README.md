# Packaging charts

## Init a new Chart

```bash
helm create basic-app-chart
```

From the default chart created by the above command, I had added environment variables management and check that liveness and readiness probes are defined.

Before to package the chart, we can make some tests:
```bash
helm lint ./basic-app-chart
```

and to check the rendered templates:
```bash
helm install test --namespace test ./basic-app-chart --dry-run --debug

helm install test --namespace test ./basic-app-chart --values ./example-values.yaml --dry-run --debug
```

### deploy
```bash
kubectl create namespace test
helm install test --namespace test ./basic-app-chart --values ./example-values.yaml
```

http://note-app-be.local/swagger-ui/index.html

undeploy:
```bash
helm uninstall test --namespace test
kubectl delete namespace test
```

# Create package
To make our charts available to our friends, colleagues, and family, we need to package it in the form of a TAR file. The following command will package your chart and generate a zipped TAR file in the current working directory.
```bash
helm package ./basic-app-chart
```

Helm supports discovering and installing charts from HTTP server. It reads the list of available charts from an index file hosted on the server and downloads charts from the location mentioned in the index file for a chart.
You can also use Helm command helm serve to serve charts from your local system.
To create the index file for your charts, execute the following command in your terminal at the same working directory where your charts are located.

```bash
helm repo index .
```

If we copy the **index file** and the **basic-app-chart** chart to a GitHub repository that we can now use as a HTTP server for our charts. Execute the following command in your terminal to add the Helm repository to your system.

```bash
helm repo add basicapprepo "https://marcelloraffaele.github.io/helm/charts/"


helm repo list
```

After adding the repo, you can search for charts available in the repository by executing the following command.
```bash
helm search basicapprepo
helm search repo basic-app-chart

``` 