locals {
#  env = terraform.workspace
  env = var.env
  app = var.app
}


# Resource Group

module "resource_group" {
  source   = "../../modules/resource_group"
  env      = local.env
  app      = local.app
  location = var.location
}


# Key Vault

module "key_vault" {
  source              = "../../modules/key_vault"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  caller_object_id    = data.azurerm_client_config.current.object_id
}


# Virtual Network

module "vnet" {
  source              = "../../modules/vnet"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name

  address_space       = "10.10.0.0/16"
  subnet_fe_prefix    = "10.10.1.0/24"
  subnet_be_prefix    = "10.10.2.0/24"
  subnet_db_prefix    = "10.10.3.0/24"
  subnet_appgw_prefix = "10.10.10.0/24"
}


# Linux VMs (FE + BE + AI)

module "vm_linux" {
  source              = "../../modules/vm_linux"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name

  subnet_fe_id = module.vnet.subnet_fe_id
  subnet_be_id = module.vnet.subnet_be_id

  vm_admin_user     = var.vm_admin_user
  vm_admin_password = var.vm_admin_password

  vm_size = "Standard_D2s_v4"
}


# Application Gateway (WAF v2)

module "app_gateway" {
  source                 = "../../modules/application_gateway"
  env                    = local.env
  app                    = local.app
  location               = var.location
  resource_group_name    = module.resource_group.name
  subnet_appgw_id        = module.vnet.subnet_appgw_id
  frontend_private_ips   = module.vm_linux.fe_private_ips
  webservice_private_ips = module.vm_linux.be_private_ips
}


# Private DNS for PostgreSQL

module "private_dns_postgres" {
  source              = "../../modules/private_dns"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_zone_name       = "privatelink.postgres.database.azure.com"
  vnet_id             = module.vnet.vnet_id
}


# PostgreSQL Flexible Server

module "postgres" {
  source                  = "../../modules/postgres"
  env                     = local.env
  app                     = local.app
  location                = var.location
  resource_group_name     = module.resource_group.name
  postgres_admin_user     = var.postgres_admin_user
  postgres_admin_password = var.postgres_admin_password
  subnet_db_id            = module.vnet.subnet_db_id
  private_dns_zone_id     = module.private_dns_postgres.dns_zone_id
}


# Storage Account

module "storage" {
  source              = "../../modules/storage"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name
}


# DNS Resolver

module "dns_resolver" {
  source                   = "../../modules/dns_resolver"
  env                      = local.env
  app                      = local.app
  location                 = module.resource_group.location
  resource_group_name      = module.resource_group.name
  vnet_id                  = module.vnet.vnet_id
  vnet_name                = module.vnet.vnet_name
  dns_resolver_subnet_cidr = "10.10.4.0/27"
}

#-------------------------------------------------------------
# OPENAI
#-------------------------------------------------------------
module "openai" {
  source              = "../../modules/openai"
  env                 = local.env
  app                 = local.app
  location            = var.location
  resource_group_name = module.resource_group.name
}

#-------------------------------------------------------------
# azure communication service
#-------------------------------------------------------------

module "communication_service" {
  source              = "../../modules/communication_service"
  env                 = local.env
  app                 = local.app
  resource_group_name = module.resource_group.name
}
