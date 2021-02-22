resource "azurerm_public_ip" "ip_game" {
  name                = "ipGame"
  sku                 = "Basic"
  resource_group_name = var.rg.name
  location            = var.rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic_game" {
  name                = "nic"
  location            = var.rg.location
  resource_group_name = var.rg.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip_game.id
    subnet_id                     = var.subnet.id
  }
}