# Setup Azure Backend for Terraform State
# Run this script to create the required Azure resources for remote state storage

# Variables (customize as needed)
$subscriptionId = "4798361b-bcde-480f-a551-3c6ea8f38b9f"
$environment = "test"
$location = "southeastasia"
$resourceGroupName = "terraform-state-rg"
$storageAccountName = "terraformstate$environment"
$containerName = "tfstate"

# Login to Azure (if not already logged in)
# az login

# Set subscription
az account set --subscription $subscriptionId

# Create resource group for Terraform state
Write-Host "Creating resource group: $resourceGroupName"
az group create --name $resourceGroupName --location $location

# Create storage account
Write-Host "Creating storage account: $storageAccountName"
az storage account create `
  --name $storageAccountName `
  --resource-group $resourceGroupName `
  --location $location `
  --sku Standard_LRS `
  --encryption-services blob

# Get storage account key
$storageKey = az storage account keys list `
  --resource-group $resourceGroupName `
  --account-name $storageAccountName `
  --query "[0].value" -o tsv

# Create blob container
Write-Host "Creating blob container: $containerName"
az storage container create `
  --name $containerName `
  --account-name $storageAccountName `
  --account-key $storageKey

Write-Host "Azure backend setup complete!"
Write-Host "Resource Group: $resourceGroupName"
Write-Host "Storage Account: $storageAccountName"
Write-Host "Container: $containerName"
Write-Host ""
Write-Host "You can now run 'terraform init' to initialize with the remote backend."