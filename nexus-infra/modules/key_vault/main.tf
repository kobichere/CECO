
resource "azurerm_key_vault" "kv" {
  name                        = "ceco-${var.app}-${var.env}-kv2"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.caller_object_id

    secret_permissions = ["Get", "Set", "List", "Delete", "Recover"]
  }
}

# dynamic "access_policy" {
#   for_each = var.appgw_identity_object_id != null ? [var.appgw_identity_object_id] : []
#   content {
#     tenant_id = var.tenant_id
#     object_id = access_policy.value
#     secret_permissions = ["Get"]
#   }
# }

# resource "azurerm_key_vault_secret" "appgw_tls_cert" {
#   name         = "ceco-${var.env}-appgw-cert"
#   key_vault_id = azurerm_key_vault.kv.id
#   value        = base64encode(file(var.appgw_cert_file))

#   tags = {
#     environment = var.env
#   }
# }



# # resource "azurerm_key_vault_secret" "postgres_user" {
# #   name         = "postgres-admin-user"
# #   value        = var.postgres_admin_user
# #   key_vault_id = azurerm_key_vault.kv.id
# # }

# # resource "azurerm_key_vault_secret" "postgres_password" {
# #   name         = "postgres-admin-password"
# #   value        = var.postgres_admin_password
# #   key_vault_id = azurerm_key_vault.kv.id
# # }

# resource "azurerm_key_vault_secret" "vm_user" {
#   name         = "vm-admin-user"
#   value        = var.vm_admin_user
#   key_vault_id = azurerm_key_vault.kv.id
# }

# resource "azurerm_key_vault_secret" "vm_password" {
#   name         = "vm-admin-password"
#   value        = var.vm_admin_password
#   key_vault_id = azurerm_key_vault.kv.id
# }

