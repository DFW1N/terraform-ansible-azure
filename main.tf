## Create unique password
resource "random_string" "password" {
  count            = 2
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

## Azure Main Resource Group Creation
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

## Azure Main Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}



## Azure Network Interface
resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "${var.prefix}-nic1-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
  }
  tags = {
    environment = "Production"
  }
}

## Azure Network Internal Interface
resource "azurerm_network_interface" "internal" {
  count               = 2
  name                = "${var.prefix}-nic2-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Production"
  }
}

## Azure subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

## Public IP Address
resource "azurerm_public_ip" "pip" {
  count               = 2
  name                = "${var.prefix}-pip-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

## Azure Network Security Group [NSG]
resource "azurerm_network_security_group" "ansible" {
  name                = "tls_${var.prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = var.approvedport
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

## Azure Network Security Group Association [NSG]
resource "azurerm_network_interface_security_group_association" "main" {
  count                     = 2
  network_interface_id      = element(azurerm_network_interface.internal.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.ansible.id
}

## Azure Linux Virtual Machine for Ansible Main Node Deployment
resource "azurerm_linux_virtual_machine" "main" {
  count                           = 2
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_F2"
  admin_username                  = var.linuxuser
  admin_password                  = element(random_string.password.*.result, count.index)
  disable_password_authentication = false
  network_interface_ids = [
    element(azurerm_network_interface.main.*.id, count.index),
    element(azurerm_network_interface.internal.*.id, count.index)
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "Production"
  }
}
