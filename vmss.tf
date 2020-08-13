resource "azurerm_windows_virtual_machine_scale_set" "windows_vmss" {
  name                 = "win-vmss"
  computer_name_prefix = "win-vmss"
  resource_group_name  = azurerm_resource_group.devtestlab.name
  location             = azurerm_resource_group.devtestlab.location
  sku                  = "Standard_F2"
  instances            = 1
  admin_username       = var.admin_username
  admin_password       = var.admin_password

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

resource "azurerm_public_ip" "win-vmss-ip" {
    allocation_method       = "Dynamic"
    idle_timeout_in_minutes = 4
    ip_version              = "IPv4"
    location                = var.location 
    name                    = "win-vmss-ip"
    resource_group_name     = azurerm_resource_group.devtestlab.name
    sku                     = "Standard"
}

resource "azurerm_lb" "win-vmss-lb" {
    location             = var.location
    name                 = "win-vmss-lb"
    resource_group_name  = azurerm_resource_group.devtestlab.name
    sku                  = "Standard"

    frontend_ip_configuration {
        name                          = "LoadBalancerFrontEnd"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        public_ip_address_id          = azurerm_public_ip.win-vmss-ip.id
    }
}