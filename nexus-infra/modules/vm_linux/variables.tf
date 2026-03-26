
# Variables
variable "app" {
  type = string
  description = "App Name = Nexus"
}

variable "env" {
  type        = string
  description = "Environment (dev, qa, prod)"
}

variable "windows_vm_name" {
  type    = string
  default = "CECO-Nx-Prod-VM"
}

variable "windows_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_fe_id" {
  type = string
}

variable "subnet_be_id" {
  type = string
}

variable "vm_admin_user" {
  type = string
}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"  #"Standard_B4ms"
}

#  VM Names 
variable "fe_vm_names" {
  type = list(string)
  default = [
    "CECO-Nexus-Prod-App-FrontEnd-Services-App-01",
    "CECO-Nexus-Prod-App-FrontEnd-Services-App-02"
  ]
}

variable "be_vm_names" {
  type = list(string)
  default = [
    "CECO-Nexus-Prod-App-Common-Services-App-01",
    "CECO-Nexus-Prod-App-Common-Services-App-02",
    "CECO-Nexus-Prod-App-Webservice",
    "CECO-Nexus-Prod-AI-Services"
  ]
}

#  AI VM Override 
variable "ai_vm_name" {
  type    = string
  default = "CECO-Nexus-Prod-AI-Services"
}

variable "ai_vm_size" {
  type    = string
  default = "Standard_D2s_v4"
}

variable "ai_vm_disk_size_gb" {
  type    = number
  default = 128
}
