resource "azurerm_linux_virtual_machine" "JumpboxVM" {
  name                            = "JumpBoxVM"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "Mypassword123"

  network_interface_ids = [
    azurerm_network_interface.Jumpbox-Nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet, azurerm_network_interface.Jumpbox-Nic]
}


resource "azurerm_linux_virtual_machine" "AppVM" {
  name                            = "AppVM"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "Mypassword123"


  network_interface_ids = [
    azurerm_network_interface.AppVMNic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
     offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet, azurerm_network_interface.AppVMNic]
}

resource "azurerm_linux_virtual_machine" "WebVM" {
  name                            = "WebVM"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "Mypassword123"


  network_interface_ids = [
    azurerm_network_interface.WebVMNic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet, azurerm_network_interface.WebVMNic]
}