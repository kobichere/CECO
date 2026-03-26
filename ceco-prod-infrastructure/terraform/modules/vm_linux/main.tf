# ---------------------------------------------------------
# Variables
# ---------------------------------------------------------

variable "env" {
  type        = string
  description = "Environment (dev, qa, prod)"
}

variable "windows_vm_name" {
  type    = string
  default = "CECO-Prod-VM"
}

variable "windows_vm_size" {
  type    = string
  default = "Standard_B2s"
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

# ---------------- VM Names ----------------
variable "fe_vm_names" {
  type = list(string)
  default = [
    "CECO-Prod-App-FrontEnd-Services-App-01",
    "CECO-Prod-App-FrontEnd-Services-App-02"
  ]
}

variable "be_vm_names" {
  type = list(string)
  default = [
    "CECO-Prod-App-Common-Services-App-01",
    "CECO-Prod-App-Common-Services-App-02",
    "CECO-Prod-App-Webservice",
    "CECO-Prod-AI-Services"
  ]
}

# ---------------- AI VM Override ----------------
variable "ai_vm_name" {
  type    = string
  default = "CECO-Prod-AI-Services"
}

variable "ai_vm_size" {
  type    = string
  default = "Standard_D2s_v4"
}

variable "ai_vm_disk_size_gb" {
  type    = number
  default = 128
}

# ---------------------------------------------------------
# Network Security Group
# ---------------------------------------------------------
resource "azurerm_network_security_group" "this" {
  name                = "ceco-${var.env}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "RDP"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# ---------------------------------------------------------
# Frontend NICs
# ---------------------------------------------------------
resource "azurerm_network_interface" "fe" {
  for_each            = toset(var.fe_vm_names)
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_fe_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "fe" {
  for_each                  = azurerm_network_interface.fe
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ---------------------------------------------------------
# Backend NICs
# ---------------------------------------------------------
resource "azurerm_network_interface" "be" {
  for_each            = toset(var.be_vm_names)
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_be_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ---------------------------------------------------------
# Windows NIC
# ---------------------------------------------------------
resource "azurerm_network_interface" "windows" {
  name                = "${var.windows_vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_be_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "windows" {
  network_interface_id      = azurerm_network_interface.windows.id
  network_security_group_id = azurerm_network_security_group.this.id
}


resource "azurerm_network_interface_security_group_association" "be" {
  for_each                  = azurerm_network_interface.be
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ---------------------------------------------------------
# Frontend VMs
# ---------------------------------------------------------
resource "azurerm_linux_virtual_machine" "fe" {
  for_each            = azurerm_network_interface.fe
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  admin_username = var.vm_admin_user
  admin_password = var.vm_admin_password
  disable_password_authentication = false

  network_interface_ids = [each.value.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ---------------------------------------------------------
# Backend VMs (AI override included)
# ---------------------------------------------------------
resource "azurerm_linux_virtual_machine" "be" {
  for_each            = azurerm_network_interface.be
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location

  size = each.key == var.ai_vm_name ? var.ai_vm_size : var.vm_size

  admin_username = var.vm_admin_user
  admin_password = var.vm_admin_password
  disable_password_authentication = false

  network_interface_ids = [each.value.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = each.key == var.ai_vm_name ? var.ai_vm_disk_size_gb : null
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ---------------------------------------------------------
# Windows VM
# ---------------------------------------------------------
resource "azurerm_windows_virtual_machine" "windows" {
  name                = var.windows_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.windows_vm_size

  admin_username = var.vm_admin_user
  admin_password = var.vm_admin_password

  network_interface_ids = [
    azurerm_network_interface.windows.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}


# ---------------------------------------------------------
# Outputs
# ---------------------------------------------------------
output "fe_vm_names" {
  value = keys(azurerm_linux_virtual_machine.fe)
}

output "be_vm_names" {
  value = keys(azurerm_linux_virtual_machine.be)
}

output "fe_private_ips" {
  value = [for nic in azurerm_network_interface.fe : nic.private_ip_address]
}

output "be_private_ips" {
  value = [for nic in azurerm_network_interface.be : nic.private_ip_address]
}

output "windows_vm_private_ip" {
  value = azurerm_network_interface.windows.private_ip_address
}

