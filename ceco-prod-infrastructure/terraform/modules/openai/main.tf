variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "azurerm_cognitive_account" "this" {
  name                = "ceco-${var.env}-openai"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.this.endpoint
}
