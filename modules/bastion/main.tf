variable "name" {
  description = "Name of the Azure Bastion host"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "ID of the AzureBastionSubnet"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID of the public IP address for Bastion"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Bastion host"
  type        = map(string)
  default     = {}
}

# Azure Bastion Host
resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "IPCONF"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }

  tags = var.tags
}

output "id" {
  description = "Bastion host ID"
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "Bastion host name"
  value       = azurerm_bastion_host.this.name
}

output "dns_name" {
  description = "Bastion host DNS name"
  value       = azurerm_bastion_host.this.dns_name
}