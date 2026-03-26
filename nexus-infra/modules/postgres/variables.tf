variable "app" {
  type = string
  description = "App Name = Nexus"
}


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
