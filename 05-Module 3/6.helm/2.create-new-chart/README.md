# Create a New Helm Chart
In this module, you will learn how to create a new Helm chart. Helm charts are packages of pre-configured Kubernetes resources that can be easily deployed and managed.

## Steps to Create a New Helm Chart
To understand Helm in detail, let’s create a Helm chart for our application. Let’s create a chart for the v1 webapp-chart application that we created earlier. Execute the following command to create a chart named webapp-chart.

```bash
helm create webapp-chart
```

This command will create a new directory named `webapp-chart` with the following structure:

```
webapp-chart
|   .helmignore
|   Chart.yaml
|   values.yaml
|   +---charts
|   +---templates
|       deployment.yaml
|       NOTES.txt
|       service.yaml
|       _helpers.tpl
```
Let’s talk briefly about the files present in the template folder:
- deployment.yaml: This file contains the YAML definition for your deployment object.
- service.yaml: This file contains the YAML definition for your service object.
- _helpers.tpl: This is a template that consists of partials and helper functions that can be used in the deployment and service definitions.
- NOTES.txt: The contents of this file are printed on the console after the chart is successfully deployed. You should write the next steps in this file that the user needs to take after deploying your chart.

The default chart template is configured to deploy nginx on a cluster. For this exercise, we will modify the default chart to deploy our service. Remember that we created a service and deployment for provisioning the first version for our application.
Let’s start by defining the service in our chart. The most important part of the chart is the contents in the templates/ directory. All Kubernetes objects, such as deployments and services, are defined in the manifests present in this directory. The easiest way to translate a manifest to the chart is to dump the manifest in this directory and use the helm install command to deploy the chart on a cluster.
Helm takes all files present in this directory through a **Go Template** rendering engine to substitute parameters present in templates with actual values to generate a valid definition. Open the file service.yaml present in the templates folder to define our service, and replace the code with the following code listing.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "webapp-chart.fullname" . }}
  labels:
    {{- include "webapp-chart.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "webapp-chart.selectorLabels" . | nindent 4 }}
```

Helm defines three objects that you can use within your templates to provide configurable values for your chart attributes: **.Release**, **.Chart**, and **.Value**. The .Release object gets values from command line. The .Chart object is used to provide information about the chart, such as the name and version. You can set values for this object in the Chart.yaml file. The .Value object exposes custom configurations for a chart. The values for this object are stored in the Values.yaml file.


To keep the chart configurable by the end user, we have used several parameters in our definitions. Let’s define the default values of these parameters in the Values.yaml file. Modify the code in the file to reflect the following code listing.
```yaml
replicaCount: 2

image:
  repository: ghcr.io/marcelloraffaele/hello
  tag: "main"

nameOverride: ""
fullnameOverride: ""

service:
  port: 8080
```

As a good practice, let’s now modify the code in the Chart.yaml file to add metadata for our chart to help the users. Modify the code to reflect the following code listing.

```yaml
apiVersion: v2
name: webapp-chart
description: Helm chart for webapp-chart v1
version: 0.1.0
```


## Deploying charts

Now that our chart is ready, let’s validate whether our chart is appropriately formed by processing it through a linter. Execute the following command in your terminal to validate your chart.

```bash
helm lint ./webapp-chart
```

Now that we have a green signal from the linter, let’s move on to deploy this chart on the local cluster with this command.
```bash
kubectl create namespace webapp
helm install webapp --namespace webapp ./webapp-chart
```
In this command, you can see that we have provided the value of the .Release.Name parameter in the command. We have used this parameter in the `/templates/_help.tpl` template and the NOTES.txt file.

```bash
helm uninstall webapp --namespace webapp
kubectl delete namespace webapp
```

## Debugging charts
Writing charts can be tricky because the templates are rendered on Tiller, which in turn sends the generated templates to the Kubernetes API server for processing. If you want to check the generated value of an expression, then comment out the expression that you want to test and execute the following command.

```bash
helm install webapp --namespace webapp ./webapp-chart --dry-run --debug
```
