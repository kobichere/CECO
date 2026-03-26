

resource "azurerm_cognitive_account" "cog_acc" {
  name                = "ceco-${var.app}-${var.env}-openai"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
}
