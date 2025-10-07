# Demo
The source code for this demo is in the [demo-servicebus](https://github.com/kedacore/sample-dotnet-worker-servicebus-queue/blob/main/connection-string-scenario.md) folder.

A simple Docker container written in .NET that will receive messages from a Service Bus queue and scale via KEDA with connection strings.

The message processor will receive a single message at a time (per instance), and sleep for 2 second to simulate performing work. When adding a massive amount of queue messages, KEDA will drive the container to scale out according to the event source (Service Bus Queue).

## Create the Service Bus Queue
```bash
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$SERVICEBUS_NAMESPACE="keda-demos-servicebus"
$SERVICEBUS_QUEUE="orders"
az servicebus namespace create --name $SERVICEBUS_NAMESPACE --resource-group $AKS_RESOURCE_GROUP --sku basic
az servicebus queue create --namespace-name $SERVICEBUS_NAMESPACE --name $SERVICEBUS_QUEUE --resource-group $AKS_RESOURCE_GROUP

az servicebus queue authorization-rule create --resource-group $AKS_RESOURCE_GROUP --namespace-name $SERVICEBUS_NAMESPACE --queue-name $SERVICEBUS_QUEUE --name order-consumer --rights Listen


#list the connection string
az servicebus queue authorization-rule keys list --resource-group $AKS_RESOURCE_GROUP --namespace-name $SERVICEBUS_NAMESPACE --queue-name $SERVICEBUS_QUEUE --name order-consumer

#
az servicebus queue authorization-rule create --resource-group $AKS_RESOURCE_GROUP --namespace-name $SERVICEBUS_NAMESPACE --queue-name orders --name keda-monitor --rights Manage Send Listen

#list the connection string
az servicebus queue authorization-rule keys list --resource-group $AKS_RESOURCE_GROUP --namespace-name $SERVICEBUS_NAMESPACE --queue-name $SERVICEBUS_QUEUE --name keda-monitor

# delete serviebus
az servicebus queue delete --resource-group $AKS_RESOURCE_GROUP --namespace-name $SERVICEBUS_NAMESPACE --name $SERVICEBUS_QUEUE
az servicebus namespace delete --resource-group $AKS_RESOURCE_GROUP --name $SERVICEBUS_NAMESPACE
```

## Deploy on AKS
```bash
$NS="keda-servicebus"
kubectl create namespace $NS

kubectl apply -f deploy.yaml -n $NS

kubectl apply -f deploy-autoscaling.yaml -n $NS

kubectl get deployments --namespace $NS -o wide

kubectl get hpa -n $NS -w

kubectl get scaledobjects -n $NS

# cleanup
kubectl delete ns $NS
```

## Send messages to the queue
```bash
git clone https://github.com/kedacore/sample-dotnet-worker-servicebus-queue
cd sample-dotnet-worker-servicebus-queue

dotnet run --project .\src\Keda.Samples.Dotnet.OrderGenerator\Keda.Samples.Dotnet.OrderGenerator.csproj

```