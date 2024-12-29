output "web_vmss_subnet_id" {
        value = azurerm_subnet.web-vmss-subnet.id
}

output "app_gateway_subnet_id" {
        value = azurerm_subnet.app_gateway.id
}

output "database_subnet_id" {
        value = azurerm_subnet.database-subnet.id
}

output "virtual_network_id" {
        value = azurerm_virtual_network.main.id
}