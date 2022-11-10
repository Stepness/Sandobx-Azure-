resource "azurerm_virtual_network" "vnet0" {
  name                = "VNet0"
  address_space       = ["10.40.0.0/20"]
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "subnet0" {
  name                 = "Subnet0"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.40.0.0/24"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.40.1.0/24"]
}

resource "azurerm_network_interface" "nic0" {
  name                = "Nic0"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet0.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.40.0.4"
    public_ip_address_id          = azurerm_public_ip.publicip0.id
  }
}

resource "azurerm_network_interface" "nic1" {
  name                = "Nic1"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.40.1.4"
    public_ip_address_id          = azurerm_public_ip.publicip1.id
  }
}

resource "azurerm_public_ip" "publicip0" {
  name                = "PublicIp0"
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "publicip1" {
  name                = "PublicIp1"
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface_security_group_association" "nsg_association0" {
  network_interface_id      = azurerm_network_interface.nic0.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}