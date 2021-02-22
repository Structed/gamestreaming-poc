
resource "azurerm_managed_disk" "gamedisk" {
  name                 = "gamedisk"
  location             = var.rg.location
  resource_group_name  = var.rg.name
  storage_account_type = "UltraSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"

  # UltraDisk Settings
  disk_iops_read_write = 10000
  disk_mbps_read_write = 600
}