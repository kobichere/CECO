

# Dedicated subnet for DNS Resolver
resource "azurerm_subnet" "dns_resolver" {
  name                 = "ceco-${var.app}-${var.env}-dnsresolver-sbnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.dns_resolver_subnet_cidr]

  delegation {
    name = "dnsresolverdelegation"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Private DNS Resolver
resource "azurerm_private_dns_resolver" "pvt_dns_resolver" {
  name                = "ceco-${var.app}-${var.env}-dnsresolver"
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id  = var.vnet_id
}

# Inbound endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  name                    = "ceco-${var.app}-${var.env}-dns-inbound"
  location                = var.location
  private_dns_resolver_id = azurerm_private_dns_resolver.pvt_dns_resolver.id

  ip_configurations {
    subnet_id = azurerm_subnet.dns_resolver.id
  }
}
