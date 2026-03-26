
resource "azurerm_storage_account" "stg_account" {
  name                     = "ceco${var.app}${var.env}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "stg_container" {
  name                  = "ceco${var.app}${var.env}"
  storage_account_id  = azurerm_storage_account.stg_account.id
  container_access_type = "private"
}
