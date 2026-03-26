variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

resource "azurerm_private_dns_zone" "this" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "ceco-${var.env}-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.vnet_id
}

output "dns_zone_id" {
  value = azurerm_private_dns_zone.this.id
}
