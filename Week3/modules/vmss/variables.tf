variable "vmss_name" {
  description = "Name of the web tier VMSS"
}

variable "location" {
  description = "Azure region"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "web_vmss_subnet_id" {
  description = "ID of the subnet"
}

variable "admin_username" {
  description = "Admin username for the VMSS"
}

variable "ssh_public_key" {
  description = "SSH public key for authentication"
}

variable "app_gateway_id" {
  description = "ID of the application gateway"
}
