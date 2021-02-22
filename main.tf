# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-boo-poc"
  location = "koreacentral"
}

resource "azurerm_virtual_network" "network_game" {
  name                = "network_game"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_game" {
  name                 = "subnet_game"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network_game.name
  address_prefixes     = ["10.0.2.0/24"]
}


module "vm" {
  source = "./game_vm"
  rg = azurerm_resource_group.rg
  subnet = azurerm_subnet.subnet_game
}