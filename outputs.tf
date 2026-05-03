output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = module.resource_group.id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = module.networking.subnet_ids
}

output "network_security_group_id" {
  description = "ID of the network security group"
  value       = module.networking.nsg_id
}

output "public_ip_addresses" {
  description = "Public IP addresses"
  value       = module.networking.public_ip_addresses
}

output "virtual_machine_id" {
  description = "ID of the virtual machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "virtual_machine_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "bastion_host_id" {
  description = "ID of the Azure Bastion host"
  value       = module.bastion.id
}

output "bastion_host_name" {
  description = "Name of the Azure Bastion host"
  value       = module.bastion.name
}

output "bastion_dns_name" {
  description = "DNS name for Bastion access"
  value       = module.bastion.dns_name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = module.storage_account.primary_blob_endpoint
}