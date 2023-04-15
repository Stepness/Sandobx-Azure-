provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-dns-westeurope"
  location = "West Europe"
}

resource "azurerm_private_dns_zone" "this" {
  name                = "mydomain.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "vnet"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_a_record" "vm1" {
  name                = "vm1"
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = [azurerm_network_interface.vm1.private_ip_address]
}

resource "azurerm_private_dns_a_record" "vm2" {
  name                = "vm2"
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = [azurerm_network_interface.vm2.private_ip_address]
}

