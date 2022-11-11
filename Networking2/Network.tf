resource "azurerm_virtual_network" "vnet1" {
  name                = "VNet1"
  address_space       = ["10.60.0.0/22"]
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "VNet2"
  address_space       = ["10.62.0.0/22"]
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_virtual_network" "vnet3" {
  name                = "VNet3"
  address_space       = ["10.63.0.0/22"]
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "subnet0" {
  name                 = "Subnet0"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.60.0.0/24"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.60.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "Subnet2"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.62.0.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "Subnet3"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.vnet3.name
  address_prefixes     = ["10.63.0.0/24"]
}

resource "azurerm_network_interface" "nic0" {
  name                 = "Nic0"
  location             = azurerm_resource_group.networking.location
  resource_group_name  = azurerm_resource_group.networking.name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet0.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.60.0.4"
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
    private_ip_address            = "10.60.1.4"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "Nic2"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.62.0.4"
  }
}

resource "azurerm_network_interface" "nic3" {
  name                = "Nic3"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet3.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.63.0.4"
  }
}

resource "azurerm_public_ip" "pi1" {
  name                = "PublicIp1"
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "pi2" {
  name                = "PublicIp2"
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface_security_group_association" "nsg_association0" {
  network_interface_id      = azurerm_network_interface.nic0.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association3" {
  network_interface_id      = azurerm_network_interface.nic3.id
  network_security_group_id = azurerm_network_security_group.this.id
}


resource "azurerm_route_table" "rt2to3" {
  name                          = "RT2to3"
  location                      = azurerm_resource_group.networking.location
  resource_group_name           = azurerm_resource_group.networking.name
  disable_bgp_route_propagation = false

  route {
    name           = "2to3"
    address_prefix = "10.63.0.0/20"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.60.0.4"
  }

}

resource "azurerm_route_table" "rt3to2" {
  name                          = "RT3to2"
  location                      = azurerm_resource_group.networking.location
  resource_group_name           = azurerm_resource_group.networking.name
  disable_bgp_route_propagation = false

    route {
    name           = "3to2"
    address_prefix = "10.62.0.0/20"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.60.0.4"
  }
}

resource "azurerm_subnet_route_table_association" "vnet2tosub0" {
  subnet_id      = azurerm_subnet.subnet2.id
  route_table_id = azurerm_route_table.rt2to3.id
}

resource "azurerm_subnet_route_table_association" "vnet3tosub0" {
  subnet_id      = azurerm_subnet.subnet3.id
  route_table_id = azurerm_route_table.rt3to2.id
}
