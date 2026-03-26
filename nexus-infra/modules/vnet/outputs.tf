# Outputs

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_fe_id" {
  value = azurerm_subnet.fe.id
}

output "subnet_be_id" {
  value = azurerm_subnet.be.id
}

output "subnet_db_id" {
  value = azurerm_subnet.db.id
}

output "subnet_appgw_id" {
  value = azurerm_subnet.appgw.id
}
