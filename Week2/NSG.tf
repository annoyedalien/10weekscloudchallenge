resource "azurerm_network_security_group" "AppNSG" {
  name                = "AppNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH-Vnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowCustom4000"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4000"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }


}

resource "azurerm_subnet_network_security_group_association" "AppNSG-associate" {
  subnet_id                 = azurerm_subnet.Vnet-AppSubnet.id
  network_security_group_id = azurerm_network_security_group.AppNSG.id

  depends_on = [azurerm_network_security_group.AppNSG]
}

resource "azurerm_network_security_group" "WebNSG" {
  name                = "WebNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH-Vnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "AllowHTTP-Vnet"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "WebNSG-associate" {
  subnet_id                 = azurerm_subnet.Vnet-WebSubnet.id
  network_security_group_id = azurerm_network_security_group.WebNSG.id

  depends_on = [azurerm_network_security_group.WebNSG]
}

resource "azurerm_network_security_group" "JumpboxNSG" {
  name                = "JumpBoxNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH-Vnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }



}

resource "azurerm_subnet_network_security_group_association" "JumpBoxNSG-associate" {
  subnet_id                 = azurerm_subnet.Vnet-JumpboxSubnet.id
  network_security_group_id = azurerm_network_security_group.JumpboxNSG.id

  depends_on = [azurerm_network_security_group.JumpboxNSG]
}