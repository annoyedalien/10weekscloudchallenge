terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}

provider "azurerm" {


  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "MyResourceGroup"
  location = var.location-rg

}