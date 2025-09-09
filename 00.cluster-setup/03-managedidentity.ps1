az aks show `
    --name $AKS_NAME `
    --resource-group $AKS_RESOURCE_GROUP `
    --query identity.principalId `
    --output tsv

