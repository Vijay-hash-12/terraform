# 1. Configure the Azure provider
provider "azurerm" {
  features {}
}

# 2. Create a Resource Group
resource "azurerm_resource_group" "v1" {
  name     = "DevOps_CaseStudy"
  location = "South India"
}

# 3. Create a Virtual Network (VNet)
resource "azurerm_virtual_network" "v1" {
  name                = "vnet-terraform-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name
}

# 4. Create a Subnet within the VNet
resource "azurerm_subnet" "v1" {
  name                 = "subnet-terraform-example"
  resource_group_name  = azurerm_resource_group.v1.name
  virtual_network_name = azurerm_virtual_network.v1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 5. Create a Network Security Group (NSG) with an SSH rule
resource "azurerm_network_security_group" "v1" {
  name                = "nsg-terraform-example"
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 6. Create a Public IP for the VM
resource "azurerm_public_ip" "v1" {
  name                = "public-ip-terraform-example"
  location            = azurerm_resource_group.v1.location
  resource_group_name = azurerm_resource_group.v1.name
  allocation_method   = "Static"
  sku                  = "Standard"
}

# 7. Create a Network Interface (NIC) and associate NSG
resource "azurerm_network_interface" "v1" {
  name                      = "nic-terraform-example"
  location                  = azurerm_resource_group.v1.location
  resource_group_name       = azurerm_resource_group.v1.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.v1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.v1.id
  }

  depends_on = [azurerm_subnet.v1]
}

# 8. Create a Linux Virtual Machine with password authentication
resource "azurerm_linux_virtual_machine" "v1" {
  name                = "Nodev"
  resource_group_name = azurerm_resource_group.v1.name
  location            = azurerm_resource_group.v1.location
  size                = "Standard_B1s"
  admin_username      = "vijaylinux"
  disable_password_authentication = false
  admin_password = "Viju_1234"

  network_interface_ids = [
    azurerm_network_interface.v1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "development"
  }
}

# 9. Output the public IP of the VM
output "public_ip" {
  value = azurerm_public_ip.v1.ip_address
