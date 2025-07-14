#What the Script Creates:
1. Virtual Network (VNet) with three subnets:

- AKS subnet (10.0.1.0/24) for the private AKS cluster
- VM subnet (10.0.2.0/24) for the management VM
- Bastion subnet (10.0.3.0/24) for Azure Bastion
2. Private AKS Cluster with:

- Private cluster configuration (no public API endpoint)
- Integrated with the VNet
- Azure CNI networking
3. Private Azure Container Registry (ACR):

- Premium SKU for private endpoint support
- Private endpoint in the VM subnet
- Attached to the AKS cluster
4. Management VM with:

- Ubuntu 22.04 LTS
- kubectl pre-installed
- Azure CLI pre-installed
- Docker pre-installed
- Kubeconfig automatically configured
- Azure Bastion for secure access to the VM

# How to Access:
Option 1: Azure Portal (Recommended)
1. Go to the Azure Portal
2. Navigate to Virtual Machines → kubectl-vm
3. Click Connect → Bastion
4. Use username: azureuser
5. Select SSH Private Key authentication
6. Use the private key that was generated (stored in ~/.ssh/id_rsa)

To access the management VM using Azure CLI and Bastion, run the following command from your local machine:

```sh
az network bastion ssh `
    --name upskilling-bastion `
    --resource-group upskilling-k8s-private-rg `
    --target-resource-id /subscriptions/$(az account show --query id -o tsv)/resourceGroups/upskilling-k8s-private-rg/providers/Microsoft.Compute/virtualMachines/kubectl-vm `
    --auth-type ssh-key `
    --username azureuser `
    --ssh-key ~/.ssh/id_rsa
```

Once connected to the VM, you can verify your Kubernetes and ACR access:

```sh
# Check cluster nodes
kubectl get nodes

# Check all pods
kubectl get pods --all-namespaces

# Check cluster info
kubectl cluster-info

# Test ACR access (after logging in with az login)
az acr login --name <your-acr-name>
```

Key Security Features:
- Private AKS: No public API server endpoint
- Private ACR: Only accessible from within the VNet
- Bastion Access: Secure SSH access without exposing VMs to the internet
- Network Segmentation: Separate subnets for different components
- NSG Rules: Restricted SSH access only from Bastion subnet
The script includes progress indicators and will provide you with all the connection details at the end. The setup ensures that your Kubernetes cluster and container registry are completely private while still allowing secure management access through the Bastion service.