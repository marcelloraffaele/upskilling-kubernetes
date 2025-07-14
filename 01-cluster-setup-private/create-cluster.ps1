# Configuration variables
$AKS_RESOURCE_GROUP="upskilling-k8s-private-rg"
$LOCATION="italynorth"
$VM_SKU="Standard_B2s"
$AKS_NAME="upskilling-aks-private"
$NODE_COUNT="2"
$ACR_NAME="acrupskilling$(Get-Random -Minimum 1000 -Maximum 9999)"
$VNET_NAME="upskilling-vnet"
$AKS_SUBNET_NAME="aks-subnet"
$VM_SUBNET_NAME="vm-subnet"
$PE_SUBNET_NAME="private-endpoint-subnet"
$BASTION_SUBNET_NAME="AzureBastionSubnet"
$VM_NAME="kubectl-vm"
$BASTION_NAME="upskilling-bastion"
$VM_USERNAME="azureuser"

Write-Host "Creating private AKS cluster with VNet, VM, and Bastion..." -ForegroundColor Green

# Create resource group
Write-Host "Creating resource group..." -ForegroundColor Yellow
az group create --location $LOCATION --resource-group $AKS_RESOURCE_GROUP

# Create Virtual Network with subnets
Write-Host "Creating Virtual Network and subnets..." -ForegroundColor Yellow
az network vnet create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $VNET_NAME `
    --address-prefixes 10.0.0.0/16 `
    --subnet-name $AKS_SUBNET_NAME `
    --subnet-prefixes 10.0.1.0/24

# Create VM subnet
az network vnet subnet create `
    --resource-group $AKS_RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --name $VM_SUBNET_NAME `
    --address-prefixes 10.0.2.0/24

# Create Bastion subnet (must be named AzureBastionSubnet)
az network vnet subnet create `
    --resource-group $AKS_RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --name $BASTION_SUBNET_NAME `
    --address-prefixes 10.0.3.0/24

# Create Private Endpoint subnet
az network vnet subnet create `
    --resource-group $AKS_RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --name $PE_SUBNET_NAME `
    --address-prefixes 10.0.4.0/24

# Get subnet IDs
$AKS_SUBNET_ID = az network vnet subnet show `
    --resource-group $AKS_RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --name $AKS_SUBNET_NAME `
    --query id -o tsv

$VM_SUBNET_ID = az network vnet subnet show `
    --resource-group $AKS_RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --name $VM_SUBNET_NAME `
    --query id -o tsv

# Create private AKS cluster
Write-Host "Creating private AKS cluster..." -ForegroundColor Yellow
az aks create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $AKS_NAME `
    --node-count $NODE_COUNT `
    --node-vm-size $VM_SKU `
    --vnet-subnet-id $AKS_SUBNET_ID `
    --enable-private-cluster `
    --private-dns-zone system `
    --network-plugin azure `
    --service-cidr 172.16.0.0/16 `
    --dns-service-ip 172.16.0.10 `
    --generate-ssh-keys `
    --enable-managed-identity

# Create Azure Container Registry with private endpoint
Write-Host "Creating Azure Container Registry..." -ForegroundColor Yellow
az acr create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $ACR_NAME `
    --sku Premium `
    --public-network-enabled false

# Create private endpoint for ACR
az network private-endpoint create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name "${ACR_NAME}-pe" `
    --vnet-name $VNET_NAME `
    --subnet $PE_SUBNET_NAME `
    --private-connection-resource-id $(az acr show --name $ACR_NAME --resource-group $AKS_RESOURCE_GROUP --query id -o tsv) `
    --group-id registry `
    --connection-name "${ACR_NAME}-connection"

# Attach ACR to AKS cluster
Write-Host "Attaching ACR to AKS cluster..." -ForegroundColor Yellow
az aks update --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --attach-acr $ACR_NAME

# Create Network Security Group for VM
Write-Host "Creating Network Security Group..." -ForegroundColor Yellow
az network nsg create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name "${VM_NAME}-nsg"

# Create NSG rule to allow SSH from Bastion subnet
az network nsg rule create `
    --resource-group $AKS_RESOURCE_GROUP `
    --nsg-name "${VM_NAME}-nsg" `
    --name "AllowSSHFromBastion" `
    --protocol tcp `
    --priority 1000 `
    --destination-port-range 22 `
    --source-address-prefixes 10.0.3.0/24 `
    --access allow

# Create public IP for VM (for initial setup, can be removed later)
az network public-ip create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name "${VM_NAME}-pip" `
    --allocation-method Static `
    --sku Standard

# Create Network Interface for VM
az network nic create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name "${VM_NAME}-nic" `
    --vnet-name $VNET_NAME `
    --subnet $VM_SUBNET_NAME `
    --network-security-group "${VM_NAME}-nsg" `
    --public-ip-address "${VM_NAME}-pip"

# Create VM with kubectl
Write-Host "Creating VM with kubectl..." -ForegroundColor Yellow
az vm create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $VM_NAME `
    --image "Ubuntu2204" `
    --admin-username $VM_USERNAME `
    --authentication-type ssh `
    --generate-ssh-keys `
    --nics "${VM_NAME}-nic" `
    --size "Standard_B2s"

# Install kubectl and Azure CLI on the VM
Write-Host "Installing kubectl and Azure CLI on VM..." -ForegroundColor Yellow
$INSTALL_SCRIPT = @"
#!/bin/bash
# Update system
sudo apt-get update

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Docker (for container operations)
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER

echo "Installation completed successfully!"
echo "kubectl version: $(kubectl version --client)"
echo "az version: $(az version --output table)"
"@

# Save the script to a temporary file and run it on the VM
$INSTALL_SCRIPT | Out-File -FilePath "install_tools.sh" -Encoding UTF8
az vm run-command invoke `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts @install_tools.sh

Remove-Item "install_tools.sh"

# Create public IP for Bastion
Write-Host "Creating Bastion..." -ForegroundColor Yellow
az network public-ip create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name "${BASTION_NAME}-pip" `
    --allocation-method Static `
    --sku Standard

# Create Azure Bastion
az network bastion create `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $BASTION_NAME `
    --public-ip-address "${BASTION_NAME}-pip" `
    --vnet-name $VNET_NAME

# Get AKS credentials and copy to VM
Write-Host "Configuring kubectl access..." -ForegroundColor Yellow
az aks get-credentials --name $AKS_NAME --resource-group $AKS_RESOURCE_GROUP --overwrite-existing

# Copy kubeconfig to VM
$KUBECONFIG_CONTENT = Get-Content "$env:USERPROFILE\.kube\config" -Raw
$COPY_KUBECONFIG_SCRIPT = @"
#!/bin/bash
mkdir -p /home/$VM_USERNAME/.kube
cat > /home/$VM_USERNAME/.kube/config << 'EOF'
$KUBECONFIG_CONTENT
EOF
chown -R $VM_USERNAME:$VM_USERNAME /home/$VM_USERNAME/.kube
chmod 600 /home/$VM_USERNAME/.kube/config
"@

$COPY_KUBECONFIG_SCRIPT | Out-File -FilePath "copy_kubeconfig.sh" -Encoding UTF8
az vm run-command invoke `
    --resource-group $AKS_RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts @copy_kubeconfig.sh

Remove-Item "copy_kubeconfig.sh"

Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "=== ACCESS INFORMATION ===" -ForegroundColor Cyan
Write-Host "Resource Group: $AKS_RESOURCE_GROUP" -ForegroundColor White
Write-Host "AKS Cluster: $AKS_NAME (Private)" -ForegroundColor White
Write-Host "ACR: $ACR_NAME (Private)" -ForegroundColor White
Write-Host "VM: $VM_NAME" -ForegroundColor White
Write-Host "VNet: $VNET_NAME" -ForegroundColor White
Write-Host "Bastion: $BASTION_NAME" -ForegroundColor White
Write-Host ""
Write-Host "=== HOW TO ACCESS ===" -ForegroundColor Cyan
Write-Host "1. Access via Azure Portal:" -ForegroundColor Yellow
Write-Host "   - Go to Azure Portal -> Virtual Machines -> $VM_NAME" -ForegroundColor White
Write-Host "   - Click 'Connect' -> 'Bastion'" -ForegroundColor White
Write-Host "   - Username: $VM_USERNAME" -ForegroundColor White
Write-Host "   - Use SSH private key authentication" -ForegroundColor White
Write-Host ""
Write-Host "2. Access via Azure CLI:" -ForegroundColor Yellow
Write-Host "   az network bastion ssh --name $BASTION_NAME --resource-group $AKS_RESOURCE_GROUP --target-resource-id /subscriptions/$(az account show --query id -o tsv)/resourceGroups/$AKS_RESOURCE_GROUP/providers/Microsoft.Compute/virtualMachines/$VM_NAME --auth-type ssh-key --username $VM_USERNAME --ssh-key ~/.ssh/id_rsa" -ForegroundColor White
Write-Host ""
Write-Host "3. Once connected to VM, test kubectl:" -ForegroundColor Yellow
Write-Host "   kubectl get nodes" -ForegroundColor White
Write-Host "   kubectl get pods --all-namespaces" -ForegroundColor White
Write-Host ""
Write-Host "Note: The VM has kubectl, Azure CLI, and Docker pre-installed" -ForegroundColor Green