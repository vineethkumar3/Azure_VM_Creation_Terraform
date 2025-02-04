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


data "azurerm_resource_group" "existing_rg" {
  name = "vineeth-resource-group"
}

data "azurerm_virtual_network" "existing_vn" {
  name                = "Vineeth-virtual"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

resource "azurerm_subnet" "new_subnet" {
  name                 = "new-subnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}
