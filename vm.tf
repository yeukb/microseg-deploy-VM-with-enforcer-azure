# Create Public IP Addresses
resource "azurerm_public_ip" "vm_pip" {
  name                    = "vm_pip-${random_id.randomId.hex}"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
  sku                     = "Standard"
}

# Create Interface for VM
resource "azurerm_network_interface" "eth0" {
  name                = "eth0"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.10.10"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}


# Create VM with Enforcer
resource "azurerm_linux_virtual_machine" "testvm" {
  name                = var.vmName
  computer_name       = var.vmName
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vmSize

  admin_username      = var.adminUsername
  admin_ssh_key {
    username   = var.adminUsername
    public_key = file(var.ssh_public_key)
  }

  network_interface_ids = [azurerm_network_interface.eth0.id]

  os_disk {
    name                   = "${var.vmName}-osdisk1"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag-storage-account.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(local.user_data)

  tags = {
    Project  = "microsegmentation-lab"
    Enforcer = "yes"
  }

  depends_on = [
    azurerm_network_interface.eth0,
    azurerm_storage_account.diag-storage-account
  ]
}
