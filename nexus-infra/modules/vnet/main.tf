
# Virtual Network

resource "azurerm_virtual_network" "vnet" {
  name                = "ceco-${var.app}-${var.env}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}


# Frontend Subnet

resource "azurerm_subnet" "fe" {
  name                 = "CECO-${var.app}-${var.env}-FE-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_fe_prefix]
}


# Backend Subnet

resource "azurerm_subnet" "be" {
  name                 = "CECO-${var.app}-${var.env}-BE-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_be_prefix]
}


# Database Subnet

resource "azurerm_subnet" "db" {
  name                 = "CECO-${var.app}-${var.env}-DB-sbnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_db_prefix]
}


# Application Gateway Subnet (MANDATORY)

resource "azurerm_subnet" "appgw" {
  name                 = "CECO-${var.app}-${var.env}-AppGW-sbnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_appgw_prefix]
}
