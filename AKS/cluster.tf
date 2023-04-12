resource "azurerm_resource_group" "kubernetes" {
  name     = "kubernetes"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "Cluster"
  location            = azurerm_resource_group.kubernetes.location
  resource_group_name = azurerm_resource_group.kubernetes.name
  dns_prefix          = "ks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}
