provider "azurerm" {
  features {}

  resource_provider_registrations = "all"
  
  subscription_id                 = "<>"
  tenant_id                       = "<>"
}

data "azurerm_client_config" "current" {}
