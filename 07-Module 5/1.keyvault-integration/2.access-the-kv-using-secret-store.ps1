# https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-identity-access?tabs=azure-portal&pivots=access-with-a-user-assigned-managed-identity
$AKS_RESOURCE_GROUP="upskilling-k8s-rg"
$AKS_NAME="upskilling-aks"
$CONNECTION_NAME="myKVConnection"
# Be sure this is the name of the key vault you created in the previous exercise
$KEYVAULT_NAME="upskilling-kv"


#####################################
$IDENTITY_OBJECT_ID= az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId -o tsv
$IDENTITY_CLIENT_ID=az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv

az role assignment create --role "Key Vault Certificate User" --assignee $IDENTITY_OBJECT_ID --scope $KEYVAULT_ID


$NS="kvsecretsstore-demo"
kubectl create namespace $NS
kubectl create -f 3.secret_provider_class.yaml -n $NS
kubectl create -f 4.pod.yaml -n $NS

kubectl exec busybox-secrets-store-inline-user-msi -n $NS -- ls /mnt/secrets-store/

kubectl exec busybox-secrets-store-inline-user-msi -n $NS -- cat /mnt/secrets-store/ExampleSecret

# Clean up
kubectl delete -f 4.pod.yaml -n $NS
kubectl delete -f 3.secret_provider_class.yaml -n $NS
kubectl delete namespace $NS