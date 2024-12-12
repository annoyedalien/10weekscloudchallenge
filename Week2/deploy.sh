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

az network vnet subnet create \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetJumpboxName" \
    --address-prefix 10.0.4.0/24

echo "Virtual Network and subnets are Created."
echo  


echo "-----------------------------------------"
echo "|            Creating NSG	               |"
echo "-----------------------------------------"

az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetJumpboxName}-NSG" \
    --location "$location"

az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetFrontendName}-NSG" \
    --location "$location"

az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetBackendName}-NSG" \
    --location "$location"

az network nsg create \
    --resource-group "$resourceGroupName" \
    --name "${subnetDatabaseName}-NSG" \
    --location "$location"

echo "NSG are Created."
echo  



echo "-----------------------------------------"
echo "|        Creating NSG Rules              |"
echo "-----------------------------------------"


az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetJumpboxName}-NSG" \
    --name "AllowSSHFromYourIP" \
    --priority 1000 \
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
    --destination-port-ranges 3306

az network nsg rule create \
    --resource-group "$resourceGroupName" \
    --nsg-name "${subnetDatabaseName}-NSG" \
    --name "AllowMySQL" \
    --priority 1000 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 3306
    
echo "NSG rules are Created."
echo  



echo "-----------------------------------------"
echo "|        Associate NSG to Subnets        |"
echo "-----------------------------------------"

az network vnet subnet update \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetJumpboxName" \
    --network-security-group "${subnetJumpboxName}-NSG"

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

az network vnet subnet update \
    --resource-group "$resourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subnetDatabaseName" \
    --network-security-group "${subnetDatabaseName}-NSG"

echo "Associated NSG to Subnets."
echo  

echo "-----------------------------------------"
echo "|        Creating Jumpbox VM             |"
echo "-----------------------------------------"
az vm create \
    --resource-group "$resourceGroupName" \
    --name "JumpboxVM" \
    --location "$location" \
    --vnet-name "$vnetName" \
    --subnet "$subnetJumpboxName" \
    --image "Ubuntu2204" \
    --admin-username "azureuser" \
    --authentication-type "ssh" \
    --ssh-key-value "~/.ssh/host_key.pub" \
    --size "Standard_B1s" \
    --public-ip-sku "Standard"\
    --no-wait

az vm create \
    --resource-group "$resourceGroupName" \
    --name "WebVM" \
    --location "$location" \
    --vnet-name "$vnetName" \
    --subnet "$subnetFrontendName" \
    --image "Ubuntu2204" \
    --admin-username "azureuser" \
    --authentication-type "ssh" \
    --ssh-key-value "~/.ssh/host_key.pub" \
    --size "Standard_B1s" \
    --public-ip-address ""\
    --no-wait

az vm create \
    --resource-group "$resourceGroupName" \
    --name "AppVM" \
    --location "$location" \
    --vnet-name "$vnetName" \
    --subnet "$subnetBackendName" \
    --image "Ubuntu2204" \
    --admin-username "azureuser" \
    --authentication-type "ssh" \
    --ssh-key-value "~/.ssh/host_key.pub" \
    --size "Standard_B1s" \
    --public-ip-address ""\
    --no-wait

echo "Jumpbox VM created."
echo  

