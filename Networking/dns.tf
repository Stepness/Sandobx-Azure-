resource "azurerm_private_dns_zone" "this" {
  name                = "contoso.org"
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet0" {
  name                  = "vnet0_virtual_link"
  resource_group_name   = azurerm_resource_group.networking.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.vnet0.id
  registration_enabled  = true
}

resource "azurerm_dns_zone" "this" {
  name                = "facehub.org"
  resource_group_name = azurerm_resource_group.networking.name
}