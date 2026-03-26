variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

resource "azurerm_resource_group" "this" {
  name     = "ceco-${var.env}-rg"
  location = var.location
}

output "name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}
