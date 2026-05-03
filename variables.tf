variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "4798361b-bcde-480f-a551-3c6ea8f38b9f"
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = "c06d3c05-9324-49c4-aba2-047714af0fc1"
}

variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
  default     = "ce8d19ba-ca15-4054-b00d-e9550e2e8a88"
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "sathavahana"
}

variable "application" {
  description = "Application name"
  type        = string
  default     = "TBD"
}

variable "business_contact" {
  description = "Business contact email"
  type        = string
  default     = "sathavahana.irragamreddy@kerry.com"
}

variable "technical_contact" {
  description = "Technical contact email"
  type        = string
  default     = "sathavahana.irragamreddy@kerry.com"
}

variable "vm_admin_username" {
  description = "VM administrator username"
  type        = string
  default     = "sathavahana"
}

variable "vm_admin_password" {
  description = "VM administrator password"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "oracle"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "southeastasia"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "apmea_sre_testing-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "apmea_sre_testing"
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_D4as_v5"
}

variable "bastion_name" {
  description = "Name of the Azure Bastion host"
  type        = string
  default     = "apmea_sre_testing"
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "apmea_sre_testing-nsg"
}

variable "vm_public_ip_name" {
  description = "Name of VM public IP"
  type        = string
  default     = "apmea_sre_testing-ip"
}

variable "bastion_public_ip_name" {
  description = "Name of Bastion public IP"
  type        = string
  default     = "apmea_sre_testing-vnet-IPv4"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "oraclemcpstg001"
}