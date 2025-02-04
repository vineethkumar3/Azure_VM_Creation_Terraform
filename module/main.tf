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
/*
terraform {
  backend "azurerm" {
    resource_group_name  = "vineeth-resource-group"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "vineethstorage"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "vineeth-container"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    access_key = ""
  }
}*/

resource "azurerm_key_vault" "example" {
  name                        = "vineethvalut2"
  location                    = var.resource-group-location
  resource_group_name         = var.resource-group-name
  enabled_for_disk_encryption = true
  tenant_id                   = ""
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = ""
    object_id = ""

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }

access_policy {
  tenant_id = ""
  object_id = ""

      secret_permissions = [
      "Get",
      "List",
      "Set"
    ]
}

}

resource "azurerm_key_vault_secret" "keyvalue" {
  name         = "ipadd"
  value        = azurerm_public_ip.public_ip.ip_address
  key_vault_id = azurerm_key_vault.example.id
}
