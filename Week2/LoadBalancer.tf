resource "azurerm_lb" "Internal-LB" {
  name                = "InternalLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "Internal-Ip"
    subnet_id                     = azurerm_subnet.Vnet-WebSubnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
  depends_on = [ azurerm_linux_virtual_machine.AppVM,azurerm_subnet.Vnet-WebSubnet ]
}

resource "azurerm_lb_backend_address_pool" "internal-backend" {
  name            = "Internal-Backend"
  loadbalancer_id = azurerm_lb.Internal-LB.id
  depends_on = [ azurerm_lb.Internal-LB ]
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  network_interface_id            = azurerm_network_interface.AppVMNic.id
  ip_configuration_name           = "internal"
  backend_address_pool_id         = azurerm_lb_backend_address_pool.internal-backend.id
  
  depends_on = [ azurerm_lb.Internal-LB, azurerm_network_interface.AppVMNic ]
}

resource "azurerm_lb_rule" "LB-rule" {
  loadbalancer_id                = azurerm_lb.Internal-LB.id
  name                           = "Http-to-Application"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 4000
  frontend_ip_configuration_name = "Internal-Ip"
depends_on = [ azurerm_lb.Internal-LB ]
}


resource "azurerm_lb_probe" "example" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.Internal-LB.id
  protocol            = "Http"
  port                = 80
  request_path        = "/health"
  interval_in_seconds = 5
  number_of_probes    = 2
  depends_on = [ azurerm_lb.Internal-LB ]
}