# Introduction to Helm

Helm is a package manager for Kubernetes that helps you manage K8s applications. Here's a basic guide to get started:

## 1. Installation

First, install Helm on your machine:

````powershell
# Using Chocolatey on Windows
choco install kubernetes-helm
````

## 2. Basic Concepts

- **Chart**: A Helm package containing K8s resource definitions
- **Repository**: Place where charts are stored
- **Release**: An instance of a chart running in a K8s cluster

## 3. Common Commands

### Add a Repository
````bash
helm repo add stable https://charts.helm.sh/stable
helm repo update
````

### Search for Charts
````bash
helm search repo nginx
````

### Install a Chart
The format is: helm install [RELEASE_NAME] [CHART]
my-release is the release name. Must be unique within your Kubernetes namespace
````bash
helm install my-release stable/nginx
````

### List Releases
````bash
helm list
````

### Uninstall a Release
````bash
helm uninstall my-release
````

## 4. Creating Your First Chart

Create a new chart:
````bash
helm create mychart
````

This creates a basic chart structure:
```
mychart/
  ├── Chart.yaml
  ├── values.yaml
  ├── templates/
  └── charts/
```

## 5. Key Files

- **Chart.yaml**: Metadata about your chart
- **values.yaml**: Default configuration values
- **templates/**: Directory containing template files

## Basic Template Example

````yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: 80
````

## 6. Deploy Your Chart

Test the template rendering:
````bash
helm template ./mychart
````

Install your chart:
````bash
helm install my-release ./mychart
````
