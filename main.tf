# Step 1: Declare the Password variable
variable "Password" {
  description = "The password for the admin user of the Linux VM"
  type        = string
  sensitive   = true
}

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
  name                 = "vijay-vnet2"  # Replace with your existing subnet name
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

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"  # SSH port for Linux VM
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.example_subnet.id
  }
}

# Create a new Linux Virtual Machine (VM) - Node VM
resource "azurerm_linux_virtual_machine" "new_vm" {
  name                = "new-vm"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_B1s"  # You can adjust the size as per your needs
  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]

  os_disk {
    caching              = "ReadWrite"  # Disk caching mode
    storage_account_type = "Standard_LRS"  # Storage type for the OS disk
  }

  admin_username = "vijaylinux"
  admin_password = var.Password  # Referencing the Password variable

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
