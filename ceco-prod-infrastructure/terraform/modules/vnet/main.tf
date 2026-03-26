variable "env" {
  type        = string
  description = "Environment (dev, qa, prod)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "address_space" {
  type        = string
  description = "VNet CIDR block"
}

variable "subnet_fe_prefix" {
  type        = string
  description = "Frontend subnet CIDR block"
}

variable "subnet_be_prefix" {
  type        = string
  description = "Backend subnet CIDR block"
}

variable "subnet_db_prefix" {
  type        = string
  description = "Database subnet CIDR block"
}

variable "subnet_appgw_prefix" {
  type        = string
  description = "Application Gateway subnet CIDR block"
}

# ---------------------------------------------------------
# Virtual Network
# ---------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "ceco-${var.env}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# ---------------------------------------------------------
# Frontend Subnet
# ---------------------------------------------------------
resource "azurerm_subnet" "fe" {
  name                 = "CECO-${var.env}-FE-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_fe_prefix]
}

# ---------------------------------------------------------
# Backend Subnet
# ---------------------------------------------------------
resource "azurerm_subnet" "be" {
  name                 = "CECO-${var.env}-BE-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_be_prefix]
}

# ---------------------------------------------------------
# Database Subnet
# ---------------------------------------------------------
resource "azurerm_subnet" "db" {
  name                 = "CECO-${var.env}-DB-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_db_prefix]
}

# ---------------------------------------------------------
# Application Gateway Subnet (MANDATORY)
# ---------------------------------------------------------
resource "azurerm_subnet" "appgw" {
  name                 = "CECO-${var.env}-AppGW-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_appgw_prefix]
}

# ---------------------------------------------------------
# Outputs
# ---------------------------------------------------------
output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
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
