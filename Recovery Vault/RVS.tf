resource "azurerm_resource_group" "example" {
  name     = "tfex-recovery_vault"
  location = "West Europe"
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "example-recovery-vault"
  location            = azurerm_resource_group.vms.location
  resource_group_name = azurerm_resource_group.vms.name
  sku                 = "Standard"

  soft_delete_enabled = true
}