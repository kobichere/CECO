

resource "azurerm_resource_group" "rg" {
  name     = "ceco-${var.app}-${var.env}-rg"
  location = var.location
}
