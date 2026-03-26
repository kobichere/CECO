variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "dns_resolver_subnet_cidr" {
  type        = string
  description = "CIDR block for DNS resolver subnet"
  default     = "10.10.4.0/27"
}

# Dedicated subnet for DNS Resolver
resource "azurerm_subnet" "dns_resolver" {
  name                 = "ceco-${var.env}-dnsresolver-subnet"
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
resource "azurerm_private_dns_resolver" "this" {
  name                = "ceco-${var.env}-dnsresolver"
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id  = var.vnet_id
}

# Inbound endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  name                    = "ceco-${var.env}-dns-inbound"
  location                = var.location
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id

  ip_configurations {
    subnet_id = azurerm_subnet.dns_resolver.id
  }
}

# Outputs
output "dns_resolver_id" {
  value = azurerm_private_dns_resolver.this.id
}

output "dns_inbound_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.inbound.ip_configurations[0].private_ip_address
}

output "dns_resolver_subnet_id" {
  value = azurerm_subnet.dns_resolver.id
}
