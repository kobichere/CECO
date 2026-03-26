variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

resource "azurerm_communication_service" "this" {
  name                = "ceco-${var.env}-acs"
  resource_group_name = var.resource_group_name

  data_location = "United States"
}

output "communication_service_id" {
  value = azurerm_communication_service.this.id
}

output "communication_service_primary_connection_string" {
  value     = azurerm_communication_service.this.primary_connection_string
  sensitive = true
}
