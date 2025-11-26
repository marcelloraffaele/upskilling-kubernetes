$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
$LOCATION="italynorth"

# enable the Azure Key Vault Secrets Store CSI Driver addon
az aks enable-addons --addons azure-keyvault-secrets-provider --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP

# verify the addon is enabled
kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver,secrets-store-provider-azure)'


# create a demo keyvault
$KEYVAULT_NAME="upskillingkv$((Get-Random -Maximum 10000))"
## Create a new Azure key vault
az keyvault create --name $KEYVAULT_NAME --resource-group $AKS_RESOURCE_GROUP --location $LOCATION --enable-rbac-authorization

## Update an existing Azure key vault
#az keyvault update --name $KEYVAULT_NAME --resource-group $AKS_RESOURCE_GROUP --location $LOCATION --enable-rbac-authorization


#####
# Get your user's object ID
$USER_OBJECT_ID = (az ad signed-in-user show --query id -o tsv)

# Get the Key Vault resource ID
$KEYVAULT_ID = (az keyvault show --name $KEYVAULT_NAME --resource-group $AKS_RESOURCE_GROUP --query id -o tsv)

# Assign Key Vault Secrets Officer role
az role assignment create --role "Key Vault Secrets Officer" --assignee $USER_OBJECT_ID --scope $KEYVAULT_ID
####

#set a plain-text secret called ExampleSecret
az keyvault secret set --vault-name $KEYVAULT_NAME --name ExampleSecret --value MyAKSExampleSecret