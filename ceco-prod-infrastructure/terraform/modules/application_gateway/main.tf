############################################
# VARIABLES
############################################
variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_appgw_id" {
  type = string
  description = "Dedicated subnet ID for Application Gateway"
}

variable "frontend_private_ips" {
  type        = list(string)
  description = "Private IPs of Frontend VMs"
}

variable "webservice_private_ips" {
  type        = list(string)
  description = "Private IPs of Webservice VMs"
  default     = []
}

##########################################
# USER ASSIGNED IDENTITY
##########################################
resource "azurerm_user_assigned_identity" "appgw" {
  name                = "ceco-${var.env}-appgw-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

############################################
# PUBLIC IP
############################################
resource "azurerm_public_ip" "appgw" {
  name                = "ceco-${var.env}-appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

############################################
# APPLICATION GATEWAY (WAF v2)
############################################
resource "azurerm_application_gateway" "this" {
  name                = "ceco-${var.env}-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  ##########################################
  # NETWORK
  ##########################################
  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = var.subnet_appgw_id
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  ##########################################
  # BACKEND POOLS
  ##########################################
  backend_address_pool {
    name        = "frontend-backend-pool"
    ip_addresses = var.frontend_private_ips
  }

  backend_address_pool {
    name        = "webservice-backend-pool"
    ip_addresses = var.webservice_private_ips
  }

  ##########################################
  # BACKEND HTTP SETTINGS
  ##########################################
  backend_http_settings {
    name                  = "http-settings"
    protocol              = "Http"
    port                  = 80
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
  }

  ##########################################
  # HTTP LISTENER
  ##########################################
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  ##########################################
  # REQUEST ROUTING RULE
  ##########################################
  request_routing_rule {
    name                       = "http-rule"
    rule_type                  = "Basic"
    http_listener_name          = "http-listener"
    backend_address_pool_name   = "frontend-backend-pool"
    backend_http_settings_name  = "http-settings"
    priority                    = 100
  }

  ##########################################
  # WAF CONFIGURATION
  ##########################################
  waf_configuration {
    enabled       = true
    firewall_mode = "Detection"
    rule_set_type = "OWASP"
    rule_set_version = "3.2"
  }

  depends_on = [
    azurerm_public_ip.appgw
  ]

  ##########################################
  # IDENTITY
  ##########################################
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw.id]
  }
}

############################################
# OUTPUTS
############################################
output "application_gateway_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}

output "application_gateway_id" {
  value = azurerm_application_gateway.this.id
}
