resource "azurerm_windows_virtual_machine_scale_set" "windows_vmss" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.devtestlab.name
  location            = azurerm_resource_group.devtestlab.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_password      = var.admin_username
  admin_username      = var.admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.devtestlab.id
    }
  }
}