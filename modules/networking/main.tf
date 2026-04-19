variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    default = {
      name             = "default"
      address_prefixes = ["10.0.0.0/24"]
    }
  }
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

variable "nsg_rules" {
  description = "List of NSG security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))
  default = {
    vm = {
      name              = "sqltesting-ip"
      allocation_method = "Static"
      sku               = "Standard"
    }
    bastion = {
      name              = "sqltesting-vnet-IPv4"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Subnets
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/26"]
}

# Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Public IPs
resource "azurerm_public_ip" "vm" {
  name                = var.public_ips["vm"].name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ips["vm"].allocation_method
  sku                 = var.public_ips["vm"].sku
  tags                = var.tags
}

resource "azurerm_public_ip" "bastion" {
  name                = var.public_ips["bastion"].name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ips["bastion"].allocation_method
  sku                 = var.public_ips["bastion"].sku
  tags                = var.tags
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value = {
    default = azurerm_subnet.default.id
    bastion = azurerm_subnet.bastion.id
  }
}

output "nsg_id" {
  description = "Network security group ID"
  value       = azurerm_network_security_group.this.id
}

output "public_ip_ids" {
  description = "Map of public IP IDs"
  value = {
    vm      = azurerm_public_ip.vm.id
    bastion = azurerm_public_ip.bastion.id
  }
}

output "public_ip_addresses" {
  description = "Map of public IP addresses"
  value = {
    vm      = azurerm_public_ip.vm.ip_address
    bastion = azurerm_public_ip.bastion.ip_address
  }
}