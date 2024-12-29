variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
}

variable "location" {
  description = "Azure Region for resources."
}
#VNET
variable "vnet_address_space" {
    description = "CIDR block for the VNet."
   
}

variable "app_gateway_subnet" {
    description = "Application Gateway subnet."
}

variable "web_vmss_subnet" {
    description = "Web VMSS subnet."
}

variable "database_subnet" {
    description = "Database subnet."
}

#VMSS
variable "vmss_name" {
  description = "Name of the web tier VMSS"
}

variable "admin_username" {
  description = "Admin username for the VMSS"
}

#Application Gateway
variable "app_gateway_name" {
  description = "Name of the Application Gateway."
}

#keyvault

variable "kv_name" {
  description = "Name of the key vault"
}

#database

variable "database_server_name" {
  description = "Name of the database"
}


variable "db_admin_username" {
  description = "Admin username for the MySQL server"
}
variable "db_admin_password" {
  description = "Admin password for the MySQL server"
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
}

variable "private_dns_zone_link_name" {
  description = "Name of the private DNS zone link"
}

