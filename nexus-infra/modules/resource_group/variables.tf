variable "app" {
  type = string
  description = "App Name = Nexus"
}


variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}