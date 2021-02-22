
resource "azurerm_managed_disk" "gamedisk_premiumssd" {
  name                 = "${var.prefix}-gamedisk-premiumssd"
  location             = var.rg.location
  resource_group_name  = var.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
}