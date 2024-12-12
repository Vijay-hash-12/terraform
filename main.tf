
provider "azurerm" {
  features {}
}

# Fetch the existing Resource Group
data "azurerm_resource_group" "example" {
  name = "DevOps_CaseStudy"  
}

# Fetch the existing Virtual Network
data "azurerm_virtual_network" "example_vnet" {
  name                = "vijay-vnet2"  
  resource_group_name = data.azurerm_resource_group.example.name
}

# Fetch the existing Subnet
data "azurerm_subnet" "example_subnet" {
  name                 = "vijay-vnet2"  
  virtual_network_name = data.azurerm_virtual_network.example_vnet.name
  resource_group_name  = data.azurerm_resource_group.example.name
}


data "azurerm_network_security_group" "example_nsg" {
  name                = "vijaynsg641"  
  resource_group_name = data.azurerm_resource_group.example.name
}


resource "azurerm_network_interface" "new_vm_nic" {
  name                      = "new-vm-nic"
  location                  = data.azurerm_resource_group.example.location
  resource_group_name       = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  
  network_interface_security_group {
    id = data.azurerm_network_security_group.example_nsg.id
  }
}


resource "azurerm_linux_virtual_machine" "new_vm" {
  name                = "new-vm"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_B1s"  # You can adjust the size as per your needs

  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]

  admin_username = "vijaylinux"
  admin_password = var.Password  

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}

# Output the private IP address of the new VM
output "new_vm_private_ip" {
  value = azurerm_network_interface.new_vm_nic.private_ip_address
}

# Define a variable for the VM admin password (this should be passed securely)
variable "Password" {
  description = "The admin password for the Linux VM"
  type        = string
  sensitive   = true  # Marking this as sensitive to ensure it is not exposed in logs
}
