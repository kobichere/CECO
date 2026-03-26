variable "app" {
  type = string
  description = "App Name = Nexus"
}

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
