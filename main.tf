terraform {
  required_version = "~> 1.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Creating Storage Account for Boot Diagnostics for Serial Console access to VMs
resource "azurerm_storage_account" "diag-storage-account" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  depends_on = [random_id.randomId]
}

# Creating random string for use in DNS Labels and Storage Account
resource "random_id" "randomId" {
  keepers = {
      # Generate a new ID only when a new resource group is defined
      resource_group = azurerm_resource_group.main.name
  }
  byte_length = 4
}













