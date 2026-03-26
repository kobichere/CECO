
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

variable "vnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "dns_resolver_subnet_cidr" {
  type        = string
  description = "CIDR block for DNS resolver subnet"
  default     = "10.10.4.0/27"
}