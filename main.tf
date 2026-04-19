# Common tags
locals {
  common_tags = {
    billingId        = "N/A"
    CreatedOnDate    = formatdate("MM/DD/YYYY", timestamp())
    DateCreated      = formatdate("MM/DD/YYYY", timestamp())
    DeletionDate     = formatdate("MM/DD/YYYY", timeadd(timestamp(), "168h")) # 7 days from now
    Environment      = var.environment
    Owner            = var.owner
    application      = var.application
    businessContact  = var.business_contact
    createdBy        = var.owner
    technicalContact = var.technical_contact
  }
}

# Resource Group Module
module "resource_group" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Networking Module
module "networking" {
  source              = "./modules/networking"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space

  subnets = {
    default = {
      name             = "default"
      address_prefixes = ["10.0.0.0/24"]
    }
    bastion = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.1.0/26"]
    }
  }

  nsg_name = var.nsg_name
  nsg_rules = [
    {
      name                       = "RDP"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  public_ips = {
    vm = {
      name              = var.vm_public_ip_name
      allocation_method = "Static"
      sku               = "Standard"
    }
    bastion = {
      name              = var.bastion_public_ip_name
      allocation_method = "Static"
      sku               = "Standard"
    }
  }

  tags = local.common_tags
}

# Virtual Machine NIC
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.networking.subnet_ids["default"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = module.networking.public_ip_ids["vm"]
  }

  tags = local.common_tags
}

# Associate NSG with VM NIC
resource "azurerm_network_interface_security_group_association" "vm_nsg" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = module.networking.nsg_id
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  license_type        = "Windows_Client"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-25h2-pro"
    version   = "latest"
  }

  tags = local.common_tags
}

# Bastion Module
module "bastion" {
  source               = "./modules/bastion"
  name                 = var.bastion_name
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  subnet_id            = module.networking.subnet_ids["bastion"]
  public_ip_address_id = module.networking.public_ip_ids["bastion"]
  tags                 = local.common_tags
}