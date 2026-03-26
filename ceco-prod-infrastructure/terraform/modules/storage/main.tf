variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "azurerm_storage_account" "this" {
  name                     = "ceco${var.env}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = "ceco${var.env}"
  storage_account_id  = azurerm_storage_account.this.id
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}
