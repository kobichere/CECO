variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralus" #"East Us"
}

variable "postgres_admin_user" {
  description = "Postgres admin username"
  type        = string
  default     = "cecoadmin"
}

variable "postgres_admin_password" {
  description = "Postgres admin password"
  type        = string
  sensitive   = true
}

variable "vm_admin_user" {
  description = "Admin username for Linux VM"
  type        = string
  default     = "cecoadmin"
}

variable "vm_admin_password" {
  description = "Admin password for Linux VM"
  type        = string
  sensitive   = true
}



