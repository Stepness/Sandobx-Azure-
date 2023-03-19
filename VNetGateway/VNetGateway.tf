provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-vnetgateway-westeurope"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-vnetgateway-westeurope"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "snet-vnetgateway-westeurope"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.255.0/27"]
}

resource "azurerm_public_ip" "this" {
  name                = "pip-vnetgateway-westeurope"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = "vgw-vnetgateway-westeurope"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  type                = "Vpn"

  ip_configuration {
    subnet_id            = azurerm_subnet.gateway-subnet.id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  vpn_client_configuration {
    address_space = [ "172.16.201.0/24" ]
    root_certificate {
      name = "MyPc-CA"
      public_cert_data = <<-EOT
                    MIIDJDCCAgwCCQDwdAE4xVle/DANBgkqhkiG9w0BAQsFADBUMQswCQYDVQQGEwJJ
                    VDEOMAwGA1UECAwFSXRhbHkxDjAMBgNVBAcMBU1pbGFuMQswCQYDVQQKDAJNZTEL
                    MAkGA1UECwwCTWUxCzAJBgNVBAMMAk1lMB4XDTIzMDMxOTE4MDQ0OFoXDTI0MDMx
                    ODE4MDQ0OFowVDELMAkGA1UEBhMCSVQxDjAMBgNVBAgMBUl0YWx5MQ4wDAYDVQQH
                    DAVNaWxhbjELMAkGA1UECgwCTWUxCzAJBgNVBAsMAk1lMQswCQYDVQQDDAJNZTCC
                    ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKXanMg+CUoqowM3vuDF3pip
                    tqyVXPkVQieSR8geKrZsvVgpNhAEnT84MgP42ADJYFVUvEo/bEmE1lHNCNUwvIIe
                    yza0Lk/ghaSrbfyg3CZ9IUAs0p2SuKE/r74nPF83c/yz8jAuzRKfhnEIMLkOwMp1
                    O1zzqN1DiT09uZRC17GF9FsGx3AEZh/z908oXBDA8sjUgzFoQ4dRmYyhRvLQ/tm3
                    k68es5TkCVY4muNGl53fKFNh+qJUsizUspNWxv4yogByOn8pWsoDS78EwmojUuyT
                    POiFcDMSvk9L/q1a5VyzWJT7hOJMvrl3SCYpofUsDPBsmzgV1YwoVURjxIIZ3YEC
                    AwEAATANBgkqhkiG9w0BAQsFAAOCAQEAKDHG0kBV3fSrS32+7iIIwBwzysPMXKXT
                    y6QgTrWyTNO1IKbBhLaA23Vz2/mipKvmOkroiJW5K5bJpVKzA7ECUy6rDMhjNaFX
                    A8dXOw8tv7jqgTCJAroAbYWtty42v3BiWPZYUmhxaPIfwJ/AId1Uosvinq35FAIb
                    yNj42slNtfG4tzYhioN1WX3wFq5NqU1jJHPAC62ZUqaKAbrN/BMRce4TY73sceri
                    RhPPYa6/h+iaRZM9nfrDBeGVS8qKSMe2GJvQ+g8+o9T4G8GxYhsn6shXm2qyrsdC
                    5fT6wk7+oRspGQVA0NNQcteI5tXYRIhuVG3zJikldZxrO+PlI5w5hA==
                EOT
    }
  }
}

resource "azurerm_local_network_gateway" "this" {
  name                = "lgw-vnetgateway-westeurope"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  gateway_address     = "4.3.2.1"
  address_space = [
    "10.0.0.0/24",
    "20.0.0.0/24"
  ]
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  name                = "cn-lgw-vnetgateway-westeurope-to-vgw-vnetgateway-westeurope"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.this.id

  shared_key = "abc123"
}
