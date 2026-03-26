output "communication_service_id" {
  value = azurerm_communication_service.comm_svc.id
}

output "communication_service_primary_connection_string" {
  value     = azurerm_communication_service.comm_svc.primary_connection_string
  sensitive = true
}
