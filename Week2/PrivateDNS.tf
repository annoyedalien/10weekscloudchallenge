resource "azurerm_private_dns_zone" "pdns" {
  name                = "mysql-serverdemo.private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_subnet.Vnet-DBSubnet]
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdns-link" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.pdns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
  depends_on            = [azurerm_subnet.Vnet-DBSubnet, azurerm_private_dns_zone.pdns]
}

resource "azurerm_mysql_flexible_server" "f-mysql-server" {
  name                   = "mysql-serverdemo"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "myadmin"
  administrator_password = "Mypassword123"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.Vnet-DBSubnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.pdns.id
  sku_name               = "B_Standard_B1ms"



  depends_on = [azurerm_private_dns_zone_virtual_network_link.pdns-link]
}


