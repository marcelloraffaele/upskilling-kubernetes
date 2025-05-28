$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$LOCATION="italynorth"

az group delete --location $LOCATION `
    --name $AKS_RESOURCE_GROUP `
    --yes `
    --no-wait
    