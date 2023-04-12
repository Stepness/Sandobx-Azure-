resource "azurerm_virtual_network" "vnet1" {
  name                = "VNet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vms.location
  resource_group_name = azurerm_resource_group.vms.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.vms.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "Nic1"
  location            = azurerm_resource_group.vms.location
  resource_group_name = azurerm_resource_group.vms.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.vms.name
  location            = azurerm_resource_group.vms.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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
}

resource "azurerm_recovery_services_vault" "rsv" {
  name                = "RSV"
  location            = azurerm_resource_group.vms.location
  resource_group_name = azurerm_resource_group.vms.name
  sku                 = "Standard"

  soft_delete_enabled = true
}