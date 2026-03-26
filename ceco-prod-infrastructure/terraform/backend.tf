terraform {
  backend "azurerm" {
    resource_group_name  = "ceco-tf-rg"
    storage_account_name = "cecotfstorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
