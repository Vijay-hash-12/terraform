# 1. Configure the Azure provider
provider "azurerm" {
  features {}
}

# 2. Create a Resource Group
resource "azurerm_resource_group" "v1" {
  name     = "DevOps_CaseStudy_vijay"
  location = "South India"  # Choose your preferred location
}

# 3. Create a Virtual Network (VNet)
resource "azurerm_virtual_network" "v1" {
  name                = "myvnet"
  address_space       = ["10.0.0.0/16"]  # Define IP address range
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name
}

# 4. Create a Subnet within the VNet
resource "azurerm_subnet" "v1" {
  name                 = "mysubnet"
  resource_group_name  = azurerm_resource_group.v1.name
  virtual_network_name = azurerm_virtual_network.v1.name
  address_prefixes     = ["10.0.1.0/24"]  # Define IP address range for subnet
}

# 5. Create Public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name
  allocation_method   = "Dynamic"
}

# 6. Create a Network Security Group (NSG) with an SSH rule (for Linux VM)
resource "azurerm_network_security_group" "v1" {
  name                = "mynsg"
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name

  security_rule {
    name                       = "ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"  # SSH port for Linux VM
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 7. Create a Network Interface (NIC) and associate NSG
resource "azurerm_network_interface" "v1" {
  name                      = "myNIC"
  location                  = azurerm_resource_group.v1.location
  resource_group_name       = azurerm_resource_group.v1.name
  ip_configuration {
    name                          = "MyNIC_conf"
    subnet_id                     = azurerm_subnet.v1.id  # Link subnet here
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id  # Link public IP
  }
}

# 8. Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "v1" {
  network_interface_id      = azurerm_network_interface.v1.id
  network_security_group_id = azurerm_network_security_group.v1.id
}

# Generate SSH key pair dynamically using the TLS provider
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create a storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.v1.location
  resource_group_name      = azurerm_resource_group.v1.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 9. Create a Linux Virtual Machine with dynamically generated SSH key
resource "azurerm_linux_virtual_machine" "example" {
  name                = "NodeV"  # VM name
  resource_group_name = azurerm_resource_group.v1.name
  location            = azurerm_resource_group.v1.location
  network_interface_ids = [azurerm_network_interface.v1.id]  # Correct NIC reference
  size                = "Standard_B1s"  # VM size

  os_disk {
    name                 = "mydisk"
    caching              = "ReadWrite"  # Disk caching mode
    storage_account_type = "Standard_LRS"  # Storage type for the OS disk
  }

  source_image_reference {
    publisher = "Canonical"  # Publisher for Ubuntu images
    offer     = "UbuntuServer"  # Offer for Ubuntu Linux OS
    sku       = "18.04-LTS"  # Choose the Ubuntu version (e.g., 18.04-LTS)
    version   = "latest"  # Use the latest version of the image
  }

  computer_name  = "Vijaylinux"
  admin_username = "Vijay"  # Admin username for the VM
  
  # Use dynamically generated SSH key
  admin_ssh_key {
    username   = "Vijay"
    public_key = tls_private_key.example.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

# Output the public IP of the VM
output "public_ip" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
}
