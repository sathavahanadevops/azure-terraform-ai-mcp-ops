variable "name" {
  description = "Name of the virtual machine"
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

variable "size" {
  description = "VM size"
  type        = string
  default     = "Standard_D4as_v5"
}

variable "admin_username" {
  description = "Administrator username"
  type        = string
}

variable "admin_password" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}

variable "network_interface_ids" {
  description = "List of network interface IDs"
  type        = list(string)
}

variable "os_disk" {
  description = "OS disk configuration"
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
  default = {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
  }
}

variable "source_image_reference" {
  description = "Source image reference"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-25h2-pro"
    version   = "latest"
  }
}

variable "license_type" {
  description = "License type for Windows VMs"
  type        = string
  default     = "Windows_Client"
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = map(string)
  default     = {}
}

# Network Interface
resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.network_interface_ids[0] # Assuming first is subnet
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id will be set by the calling module if needed
  }

  tags = var.tags
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  license_type        = var.license_type

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  tags = var.tags
}

output "id" {
  description = "Virtual machine ID"
  value       = azurerm_windows_virtual_machine.this.id
}

output "name" {
  description = "Virtual machine name"
  value       = azurerm_windows_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "Network interface ID"
  value       = azurerm_network_interface.this.id
}