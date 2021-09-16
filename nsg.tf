# Create NSG for Management interface
resource "azurerm_network_security_group" "mgmt" {
  name                = "Mgmt-NSG-${random_id.randomId.hex}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.AllowedSourceIPRange
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.AllowedSourceIPRange
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.main]
}
