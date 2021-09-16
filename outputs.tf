output "VM_IP" {
    value = azurerm_linux_virtual_machine.testvm.public_ip_address
}
