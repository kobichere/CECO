
# Outputs

output "fe_vm_names" {
  value = keys(azurerm_linux_virtual_machine.fe)
}

output "be_vm_names" {
  value = keys(azurerm_linux_virtual_machine.be)
}

output "fe_private_ips" {
  value = [for nic in azurerm_network_interface.fe : nic.private_ip_address]
}

output "be_private_ips" {
  value = [for nic in azurerm_network_interface.be : nic.private_ip_address]
}

output "windows_vm_private_ip" {
  value = azurerm_network_interface.windows.private_ip_address
}
