terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

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

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate 
  sensitive = true
  
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw

  sensitive = true
}