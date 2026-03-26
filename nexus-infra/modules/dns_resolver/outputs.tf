# Outputs
output "dns_resolver_id" {
  value = azurerm_private_dns_resolver.pvt_dns_resolver.id
}

output "dns_inbound_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.inbound.ip_configurations[0].private_ip_address
}

output "dns_resolver_subnet_id" {
  value = azurerm_subnet.dns_resolver.id
}
