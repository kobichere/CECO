
# Variables
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

