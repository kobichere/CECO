

resource "azurerm_communication_service" "comm_svc" {
  name                = "ceco-${var.env}-acs"
  resource_group_name = var.resource_group_name

  data_location = "United States"
}
