module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_address_space  = var.vnet_address_space
  app_gateway_subnet  = var.app_gateway_subnet
  web_vmss_subnet     = var.web_vmss_subnet
  database_subnet     = var.database_subnet
  depends_on          = [module.resource_group]
}

module "keyvault" {
  source = "./modules/keyvault"

  kv_name             = var.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [module.resource_group]
}

module "application_gateway" {
  source = "./modules/application_gateway"

  app_gateway_name      = var.app_gateway_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  app_gateway_subnet_id = module.network.app_gateway_subnet_id
  app_gateway_public_ip = module.application_gateway.app_gateway_public_ip
  user_assigned_identity_id = module.keyvault.user_assigned_identity_id
  kv_secret_identifier      = module.keyvault.kv_secret_identifier

  depends_on = [module.network, module.resource_group, module.keyvault]
}

module "vmss" {
  source = "./modules/vmss"

  vmss_name           = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  web_vmss_subnet_id  = module.network.web_vmss_subnet_id
  app_gateway_id      = module.application_gateway.app_gateway_id
  admin_username      = var.admin_username
  ssh_public_key      = file("host_key.pub")

  depends_on = [module.network, module.resource_group, module.application_gateway]
}

module "azure_database" {
  source = "./modules/azure_database"

  resource_group_name        = var.resource_group_name
  location                   = var.location
  database_server_name              = var.database_server_name
  db_admin_username             = var.db_admin_username
  db_admin_password             = var.db_admin_password
  private_dns_zone_name      = var.private_dns_zone_name
  private_dns_zone_link_name = var.private_dns_zone_link_name
  virtual_network_id         = module.network.virtual_network_id
  database_subnet_id         = module.network.database_subnet_id

  depends_on = [module.resource_group, module.network]

}


