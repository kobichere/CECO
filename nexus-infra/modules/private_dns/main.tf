
resource "azurerm_private_dns_zone" "pvt_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pvt_dns_zone_vnetlink" {
  name                  = "ceco--${var.app}-${var.env}-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pvt_dns_zone.name
  virtual_network_id    = var.vnet_id
}
