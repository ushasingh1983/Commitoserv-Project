# testfile 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Simple Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tf-test-rg"
  location = "East US"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
Pashyant
