variable "rg" {
  description = "The resource group in which to deploy the VM"
}

variable "subnet" {
  description = "The subnet to which the VM's nic shall be added"
}

resource "azurerm_public_ip" "ip_game" {
  name                = "ipGame"
  sku                 = "Basic"
  resource_group_name = var.rg.name
  location            = var.rg.location #.rg.location
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

resource "azurerm_linux_virtual_machine" "vm_game" {
  name                = "vmgame"
  resource_group_name = var.rg.name
  location            = var.rg.location
  # size                = "Standard_NC8as_T4_v3"
  size                = "Standard_D48s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic_game.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
