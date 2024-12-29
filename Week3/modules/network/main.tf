resource "azurerm_virtual_network" "main" {
    name                = "Vnet1"
    address_space       = [var.vnet_address_space]
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "app_gateway" {
    name                 = "app-gateway-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.app_gateway_subnet]
}

resource "azurerm_subnet" "web-vmss-subnet" {
    name                 = "web-vmss-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.web_vmss_subnet]
}

resource "azurerm_subnet" "database-subnet" {
    name                 = "database-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.database_subnet]
  delegation {
    name = "database-delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

}

# NSG rules for web tier subnet
resource "azurerm_network_security_group" "web_vmss_nsg" {
    name                = "web-vmss-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowHTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = var.web_vmss_subnet
    }
    depends_on = [ azurerm_subnet.web-vmss-subnet ]
}

resource "azurerm_network_security_group" "database_nsg" {
    name                = "database-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowMySQL"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = var.database_subnet
    }
    depends_on = [ azurerm_subnet.database-subnet ]
}

resource "azurerm_subnet_network_security_group_association" "web_vmss_nsg_association" {
    subnet_id                 = azurerm_subnet.web-vmss-subnet.id
    network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id
    depends_on = [ azurerm_network_security_group.web_vmss_nsg ]
}

resource "azurerm_subnet_network_security_group_association" "database_nsg_association" {
    subnet_id                 = azurerm_subnet.database-subnet.id
    network_security_group_id = azurerm_network_security_group.database_nsg.id
    depends_on = [ azurerm_network_security_group.database_nsg ]
}
