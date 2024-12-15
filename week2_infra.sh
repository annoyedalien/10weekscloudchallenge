#!/bin/bash

# Variables
resourceGroupName="MyResourceGroup"
location="East Asia"
vnetName="MyVnet"
subnetJumpboxName="Jumpbox-Subnet"
subnetFrontendName="Web-Subnet"
subnetBackendName="App-Subnet"
subnetDatabaseName="DB-Subnet"
subnetAppGWName="Appgw-Subnet"

#mykey=$(cat ~/.ssh/host_key.pub)

#ssh-keygen -t rsa -f host_key

yourPublicIP=$(curl -s https://api.ipify.org)

echo "-----------------------------------------"
echo "|        Creating Resource Group        |"
echo "-----------------------------------------"

az group create --name "$resourceGroupName" --location "$location"
echo "Resource Group is Created."
echo  


echo "-----------------------------------------"
echo "|        Creating Virtual Networks       |"
echo "-----------------------------------------"

az network vnet create \
    --resource-group "$resourceGroupName" \
    --name "$vnetName" \
    --location "$location" \
    --address-prefixes 10.0.0.0/16 \
    --subnet-name "$subnetAppGWName" \
    --subnet-prefix 10.0.0.0/24

az network vnet subnet create \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetFrontendName" \
    --address-prefix 10.0.1.0/24

az network vnet subnet create \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetBackendName" \
    --address-prefix 10.0.2.0/24

az network vnet subnet create \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetDatabaseName" \
    --address-prefix 10.0.3.0/24


echo "Virtual Network and subnets are Created."
echo  


echo "-----------------------------------------"
echo "|            Creating NSG	               |"
echo "-----------------------------------------"


az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetFrontendName}-NSG" \
    --location "$location"

az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetBackendName}-NSG" \
    --location "$location"


echo "NSG are Created."
echo  



echo "-----------------------------------------"
echo "|        Creating NSG Rules              |"
echo "-----------------------------------------"


az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetFrontendName}-NSG" \
    --name "AllowSSHFromYourIP" \
    --priority 100 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "$yourPublicIP" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22

az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetFrontendName}-NSG" \
    --name "AllowHTTP" \
    --priority 1000 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 80

az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetBackendName}-NSG" \
    --name "AllowSSHFromYourIP" \
    --priority 100 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "$yourPublicIP" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22


az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetBackendName}-NSG" \
    --name "AllowHTTP" \
    --priority 1000 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 80

az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetBackendName}-NSG" \
    --name "AllowMySQL" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 3000
    
echo "NSG rules are Created."
echo  



echo "-----------------------------------------"
echo "|        Associate NSG to Subnets        |"
echo "-----------------------------------------"



az network vnet subnet update \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetFrontendName" \
    --network-security-group "${subnetFrontendName}-NSG"

az network vnet subnet update \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetBackendName" \
    --network-security-group "${subnetBackendName}-NSG"


echo "Associated NSG to Subnets."
echo  
   

az vm create \
    --resource-group "$resourceGroupName" \
    --name "WebVM" \
    --location "$location" \
    --vnet-name "$vnetName" \
    --subnet "$subnetFrontendName" \
    --image "Ubuntu2204" \
    --admin-username "azureuser" \
    --admin-password "MyPassword123" \
    --size "Standard_B2s" \
    --nsg "" 

az vm create \
    --resource-group "$resourceGroupName" \
    --name "AppVM" \
    --location "$location" \
    --vnet-name "$vnetName" \
    --subnet "$subnetBackendName" \
    --image "Ubuntu2204" \
    --admin-username "azureuser" \
    --admin-password "MyPassword123" \
    --size "Standard_B2s" \
    --nsg "" 

echo "VMs CREATED."
echo  

echo "-----------------------------------------"
echo "|        Creating MySQL Database         |"
echo "-----------------------------------------"

az mysql flexible-server create \
 --resource-group "$resourceGroupName" \
 --name "mysql-serverdemo" \
 --vnet "$vnetName" \
 --subnet "$subnetDatabaseName"\
 --private-dns-zone  mysql-serverdemo.private.mysql.database.azure.com\
 --admin-user "mysqladmin" \
 --admin-password "MyPassword123" 


echo "MySQL DB created."
echo  

