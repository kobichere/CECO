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