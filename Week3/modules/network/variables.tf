variable "resource_group_name" {
    description = "Name of the Azure Resource Group."
}

variable "vnet_address_space" {
    description = "Vnet Address space."
}

variable "location" {
  description = "Azure Region for resources."
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