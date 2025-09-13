# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Resource group where resources will be created
resource "azurerm_resource_group" "my_resource_group" {
  name     = "myResourceGroup"
  location = "East US"
}

# Virtual network configuration
resource "azurerm_virtual_network" "my_vnet" {
  name                = "myVNet"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for the VM
resource "azurerm_subnet" "my_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network interface for the VM
resource "azurerm_network_interface" "my_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  subnet_id           = azurerm_subnet.my_subnet.id

  # Optional: Public IP address configuration
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create the virtual machine
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "myVM"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  size                = "Standard_B1s"  # Adjust the VM size as needed
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!"  # Avoid hardcoding passwords in production!

  # Specify the image (you can find available images on Azure)
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Optional: Custom data for initialization (script to run on startup)
  custom_data = <<-EOT
    #!/bin/bash
    echo "Hello, World!" > /home/adminuser/hello.txt
  EOT
}

# Output the public IP address of the VM (if you configured a public IP)
output "vm_public_ip" {
  value = azurerm_network_interface.my_nic.private_ip_address
}
