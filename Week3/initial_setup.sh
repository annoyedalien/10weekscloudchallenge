#!/bin/bash


#Create a ssh key host_key
ssh-keygen -t rsa  -f host_key


RG=TFState-RG
SA=tfstatestrgeaccnt
Container=tfstate

# Resource group
az group create --name $RG --location 'southeast asia' 

# account
az storage account create --resource-group $RG --name $SA --sku Standard_LRS --encryption-services blob

# container
az storage container create --name $Container --account-name $SA
