variable "app" {
  type = string
  description = "App Name = Nexus"
}

variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}