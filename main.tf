# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Fetch the existing Resource Group
data "azurerm_resource_group" "example" {
  name = "DevOps_CaseStudy"  # Replace with your existing resource group name
}

# Fetch the existing Virtual Network
data "azurerm_virtual_network" "example_vnet" {
  name                = "vijay-vnet2"  # Replace with your existing virtual network name
  resource_group_name = data.azurerm_resource_group.example.name
}

# Fetch the existing Subnet
data "azurerm_subnet" "example_subnet" {
  name                 = "your-subnet-name"  # Replace with the actual subnet name
  virtual_network_name = data.azurerm_virtual_network.example_vnet.name
  resource_group_name  = data.azurerm_resource_group.example.name
}

# Fetch the existing Network Security Group (NSG)
data "azurerm_network_security_group" "example_nsg" {
  name                = "vijaynsg641"  # Replace with your existing NSG name
  resource_group_name = data.azurerm_resource_group.example.name
}

# Create the Network Interface for the new VM
resource "azurerm_network_interface" "new_vm_nic" {
  name                      = "new-vm-nic"
  location                  = data.azurerm_resource_group.example.location
  resource_group_name       = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  network_security_group_id = data.azurerm_network_security_group.example_nsg.id
}

# Create a new Linux Virtual Machine (VM) - Node VM
resource "azurerm_linux_virtual_machine" "new_vm" {
  name                = "new-vm"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_B1s"  # You can adjust the size as per your needs

  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]

  admin_username = "vijaylinux"
  admin_password = Password  # Use a variable for the password (recommended for sensitive data)

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
variable "vm_admin_password" {
  description = "The admin password for the Linux VM"
  type        = string
  sensitive   = true
}
