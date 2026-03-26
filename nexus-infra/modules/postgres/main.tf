
# Create PostgreSQL Flexible Server (public enabled so PE can attach)
resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                   = "ceco-${var.app}-${var.env}-pg"
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
resource "azurerm_private_endpoint" "postgresql_pe" {
  name                = "ceco-${var.app}-${var.env}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_db_id

  private_service_connection {
    name                           = "${var.app}-pg-priv-conn"
    private_connection_resource_id = azurerm_postgresql_flexible_server.postgresql.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.app}-pg-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}
