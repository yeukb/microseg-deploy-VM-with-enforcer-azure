# Create a virtual network
resource "azurerm_virtual_network" "network" {
  name                = "VM-VNET"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["192.168.0.0/16"]

  depends_on = [azurerm_resource_group.main]
}

#Create subnet
resource "azurerm_subnet" "subnet" {
    name                      = "vm-subnet"
    resource_group_name       = azurerm_resource_group.main.name
    address_prefixes          = ["192.168.10.0/24"]
    virtual_network_name      = azurerm_virtual_network.network.name

    depends_on = [azurerm_virtual_network.network]
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}
