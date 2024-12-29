# Deploying a Two tier web application using Terraform
This contains modules in terraform that will deploy the following resources
* Resource Group
* Virtual Networks (Subnets and NSGs)
* Public IP address for the Application gateway
* Azure MySQL Flexible Server
* Application Gateway
* Virtual Machine Scale set
* Key vault and certificate
* Managed Identities

## To get started
Modify the initial_setup.sh with the based on your on preference of configuration

#### initial_setup.sh
* This will generate a ssh key on the main folder name 'host_key'
* create a resource group for the storage account
* create a storage account
* create a container

## Create a .tfvars file for the values of variables of the main.tf file

### .tfvars

```
#Resource group
resource_group_name = "" //Resource Group Name
location            = "" //Region

# VNet Address Space and Subnet
vnet_address_space = "" //Vnet Address Space
app_gateway_subnet = "" //App gateway subnet
web_vmss_subnet    = "" // WebVMSS subnet
database_subnet    = "" //Database subnet

#VMSS
vmss_name      = "" //Virtual Machine scale set name
admin_username = "" //Admin user of the VMSS

#Application Gateway
app_gateway_name = "" //App gateway name

#keyvault
kv_name = "" //Key vault name

#database
db_admin_username          = "" //Database user admin name
db_admin_password          = "" //Database admin password
database_server_name       = "" //Database server name
private_dns_zone_name      = "" //Private DNS zone example:(private.mysql.database.azure.com)
private_dns_zone_link_name = "" //database_server_name+private_dns_zone_name
```
## Initialize Terraform
```
terraform init
```

## Format, Validate and Plan

```
terraform fmt
terraform validate
terraform plan
```

## Apply the plan

```
terraform apply
```

## Cleaning up or Destroy

```
terraform destroy
```
