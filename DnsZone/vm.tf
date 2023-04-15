resource "azurerm_linux_virtual_machine" "first" {
  name                            = "vm1-dns-westeurope"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Test123"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  boot_diagnostics {
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "second" {
  name                            = "vm2-dns-westeurope"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Test123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm2.id,
  ]

  boot_diagnostics {
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}