terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id=""
  client_id=""
  client_secret = ""
  tenant_id = ""
}



resource "azurerm_resource_group" "rsg" {
  name     = var.resource-group-name
  location = var.resource-group-location
}

resource "azurerm_virtual_network" "vn" {
  name                = var.virtual-network-name
  address_space       = ["10.0.0.0/16"]
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
}

resource "azurerm_subnet" "snet1" {
  name                 = var.subnet-name
  resource_group_name  = var.resource-group-name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["${var.ipadd}"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vineeth-public-ip"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  allocation_method   = "Dynamic"
 
}

/*data "azurerm_public_ip" "ipadd"{
  name = "vineeth-public-ip"
  resource_group_name = var.resource-group-name
}*/


resource "azurerm_network_interface" "net-interface" {
  name                = var.net-interface
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id   = azurerm_public_ip.public_ip.ip_address
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.machine-name
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Vineeth1245$67"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.net-interface.id,
  ]

 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_storage_account" "storage" {
  name                     = "vineethstorage"
  resource_group_name      = var.resource-group-name
  location                 = var.resource-group-location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
terraform {
  backend "azurerm" {
    resource_group_name  = "vineeth-resource-group"  
    storage_account_name = "vineethstorage"                     
    container_name       = "vineeth-container"                     
    key                  = "prod.terraform.tfstate"       
    access_key = ""
  }
}

