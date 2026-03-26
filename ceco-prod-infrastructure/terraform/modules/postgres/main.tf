variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "postgres_admin_user" {
  type = string
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}

variable "subnet_db_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "sku_name" {
  description = "Postgres SKU (e.g. GP_Standard_D2s_v3)"
  type        = string
  default     = "B_Standard_B1ms"  #"GP_Standard_D2s_v3"
}

variable "storage_mb" {
  description = "Postgres storage size in MB"
  type        = number
  default     = 32768
}

# Create PostgreSQL Flexible Server (public enabled so PE can attach)
resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "ceco-${var.env}-pg"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16"
  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password

  storage_mb = var.storage_mb
  sku_name   = var.sku_name

  # allow Private Endpoint attachment
  public_network_access_enabled = false
  zone                          = "1"
}

# Private Endpoint for PostgreSQL
resource "azurerm_private_endpoint" "this" {
  name                = "ceco-${var.env}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_db_id

  private_service_connection {
    name                           = "pg-priv-conn"
    private_connection_resource_id = azurerm_postgresql_flexible_server.this.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pg-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}
