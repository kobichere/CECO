provider "azurerm" {
  features {}
  subscription_id = "0c709388-1122-4797-a1d7-807ecda6ada3"
}

data "azurerm_client_config" "current" {}
