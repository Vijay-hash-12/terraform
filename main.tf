

# Step 1: Declare the Password variable
variable "Password" {
  description = "The password for the admin user of the Linux VM"
  type        = string
  sensitive   = true  # This hides the password value in output or logs
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Fetch the existing Resource Group
data "azurerm_resource_group" "example" {
  name = "DevOps_CaseStudy"  # Replace with your existing resource group name
  location = "South India"
}

# Fetch the existing Virtual Network
data "azurerm_virtual_network" "example_vnet" {
  name                = "vijay-vnet2"  # Replace with your existing virtual network name
  resource_group_name = data.azurerm_resource_group.example.name
 location            = azurerm_resource_group.example.location
}

# Fetch the existing Subnet
data "azurerm_subnet" "example_subnet" {
  name                 = "vijay-vnet2"  # Replace with your existing subnet name
  virtual_network_name = data.azurerm_virtual_network.example_vnet.name
  resource_group_name  = data.azurerm_resource_group.example.name
   location            = azurerm_resource_group.example.location
}

# Fetch the existing Network Security Group (NSG)
data "azurerm_network_security_group" "example_nsg" {
  name                = "vijaynsg641"  # Replace with your existing NSG name
  resource_group_name = data.azurerm_resource_group.example.name
   location            = azurerm_resource_group.example.location
}

# Create the Network Interface for the new VM
resource "azurerm_network_interface" "new_vm_nic" {
  name                      = "new-vm-nic"
  location                  = data.azurerm_resource_group.example.location
  resource_group_name       = data.azurerm_resource_group.example.name

  # Network security group is referenced via an association with the NIC
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
  size                = "Standard_B1s"  # Adjust VM size as needed
  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]

  os_disk {
    caching              = "ReadWrite"  # Disk caching mode
    storage_account_type = "Standard_LRS"  # Storage type for the OS disk
  }

  admin_username = "vijaylinux"
  admin_password = var.Password  # Using the Password variable for VM admin password

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  # Ensure boot diagnostics is enabled for the VM
  boot_diagnostics {
    enabled              = true
    storage_account_uri  = "https://diag${random_id.random_id.hex}.blob.core.windows.net"
  }
}

# Random ID for generating a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    resource_group = azurerm_resource_group.example.name
  }
  byte_length = 8
}

# Create a Storage Account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = data.azurerm_resource_group.example.location
  resource_group_name      = data.azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Output the private IP of the new VM
output "new_vm_private_ip" {
  value = azurerm_network_interface.new_vm_nic.private_ip_address
}

