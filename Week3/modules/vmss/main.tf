resource "azurerm_linux_virtual_machine_scale_set" "web-vmss" {
    name                = var.vmss_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku                 = "Standard_B1ms"
    instances           = 2
    admin_username      = var.admin_username
    computer_name_prefix = var.vmss_name
    upgrade_mode        = "Automatic"

    admin_ssh_key {
        username   = var.admin_username
        public_key = file("host_key.pub")
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
    }

    os_disk {
        storage_account_type = "Standard_LRS"
        caching              = "ReadWrite"
    }

    network_interface {
        name    = "${var.vmss_name}-nic"
        primary = true

        ip_configuration {
            name      = "ipconfig1"
            primary   = true
            subnet_id = var.web_vmss_subnet_id
            application_gateway_backend_address_pool_ids = var.app_gateway_id
        }
    }

    custom_data = filebase64("./modules/vmss/customdata.tpl")
}