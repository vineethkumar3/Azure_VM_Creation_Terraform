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
  subscription_id="9086104b-c120-4eb7-ad44-64024bb5662b"
  client_id="5c6014f4-2bd8-4d21-b52f-0a23f421665f"
  client_secret = "yRj8Q~Wu-iKu1jae0gXEU5xDK3qvLFcm5OQoKdmU"
  tenant_id = "e1d367c8-fdcf-42d1-a1b8-ec6056e31c91"
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
