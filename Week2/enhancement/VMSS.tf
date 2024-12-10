resource "azurerm_linux_virtual_machine_scale_set" "App-VMSS" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "azureuser"
  admin_password = "Mypassword123"
  upgrade_mode = "Automatic"
  zone_balance = true
  zones = [1,2]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Premium_ZRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "AppVMSSnet"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.Vnet-AppSubnet.id
    }

    
  }
}