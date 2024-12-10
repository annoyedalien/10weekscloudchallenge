resource "azurerm_network_interface" "Jumpbox-Nic" {
  name                = "Jumpbox-Nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.Vnet-JumpboxSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Jumpbox-pip.id

  }
  depends_on = [azurerm_resource_group.rg, azurerm_public_ip.Jumpbox-pip, azurerm_virtual_network.vnet]

}

resource "azurerm_network_interface" "AppVMNic" {
  name                = "AppVMNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Vnet-AppSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
}

resource "azurerm_network_interface" "WebVMNic" {
  name                = "WebVMNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Vnet-WebSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
}
