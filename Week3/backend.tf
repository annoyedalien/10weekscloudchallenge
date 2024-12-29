terraform {
  backend "azurerm" {
    resource_group_name  = "TFState-RG"
    storage_account_name = "tfstatestrgeaccnt"
    container_name       = "tfstate"
    key                  = "./terraform.tfstate"
  }
}