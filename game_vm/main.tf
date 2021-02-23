locals {
  vm_name = var.prefix
}

resource "azurerm_linux_virtual_machine" "vm_game" {
  count               = var.windows ? 0 : 1
  name                = local.vm_name
  resource_group_name = var.rg.name
  location            = var.rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic_game.id,
  ]
  
  additional_capabilities {
    ultra_ssd_enabled = true
  }

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

resource "azurerm_windows_virtual_machine" "vm_game" {
  count               = var.windows ? 1 : 0
  name                = local.vm_name
  resource_group_name = var.rg.name
  location            = var.rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic_game.id,
  ]
  
  additional_capabilities {
    ultra_ssd_enabled = true
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

data "azurerm_virtual_machine" "vm" {
  name = local.vm_name
  resource_group_name = var.rg.name
  depends_on    = [azurerm_linux_virtual_machine.vm_game, azurerm_windows_virtual_machine.vm_game]
}

resource "azurerm_virtual_machine_data_disk_attachment" "gamedisk_ultradisk_attachment" {
  managed_disk_id    = azurerm_managed_disk.gamedisk_ultradisk.id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = "10"
  caching            = "None"
}
resource "azurerm_virtual_machine_data_disk_attachment" "gamedisk_premiumssd_attachment" {
  managed_disk_id    = azurerm_managed_disk.gamedisk_premiumssd.id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = "20"
  caching            = "None"
}
