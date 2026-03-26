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

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "caller_object_id" {
  type        = string
  description = "Object ID of the current caller"
}

# variable "appgw_identity_object_id" {
#   type        = string
#   description = "Object ID of Application Gateway User Assigned Identity"
#   default     = null
# }

# variable "appgw_cert_file" {
#   description = "Path to the PFX certificate file for Application Gateway"
#   type        = string
# }

# variable "appgw_cert_password" {
#   description = "Password for the PFX certificate"
#   type        = string
#   sensitive   = true
# }



# # variable "postgres_admin_user" {
# #   type        = string
# #   description = "Postgres admin username"
# # }

# # variable "postgres_admin_password" {
# #   type        = string
# #   description = "Postgres admin password"
# #   sensitive   = true
# # }

# variable "vm_admin_user" {
#   type        = string
#   description = "VM admin username"
# }

# variable "vm_admin_password" {
#   type        = string
#   description = "VM admin password"
#   sensitive   = true
# }

resource "azurerm_key_vault" "this" {
  name                        = "ceco-${var.env}-kv2"
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
#   key_vault_id = azurerm_key_vault.this.id
#   value        = base64encode(file(var.appgw_cert_file))

#   tags = {
#     environment = var.env
#   }
# }



# # resource "azurerm_key_vault_secret" "postgres_user" {
# #   name         = "postgres-admin-user"
# #   value        = var.postgres_admin_user
# #   key_vault_id = azurerm_key_vault.this.id
# # }

# # resource "azurerm_key_vault_secret" "postgres_password" {
# #   name         = "postgres-admin-password"
# #   value        = var.postgres_admin_password
# #   key_vault_id = azurerm_key_vault.this.id
# # }

# resource "azurerm_key_vault_secret" "vm_user" {
#   name         = "vm-admin-user"
#   value        = var.vm_admin_user
#   key_vault_id = azurerm_key_vault.this.id
# }

# resource "azurerm_key_vault_secret" "vm_password" {
#   name         = "vm-admin-password"
#   value        = var.vm_admin_password
#   key_vault_id = azurerm_key_vault.this.id
# }

# # output "postgres_admin_user" {
# #   value = azurerm_key_vault_secret.postgres_user.value
# # }

# # output "postgres_admin_password" {
# #   value     = azurerm_key_vault_secret.postgres_password.value
# #   sensitive = true
# # }

# output "vm_admin_user" {
#   value = azurerm_key_vault_secret.vm_user.value
# }

# output "vm_admin_password" {
#   value     = azurerm_key_vault_secret.vm_password.value
#   sensitive = true
# }
