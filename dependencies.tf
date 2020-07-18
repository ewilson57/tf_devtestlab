resource "azurerm_resource_group" "devtestlab" {
  location = var.location
  name     = "devtestlab"
  tags     = {}
}

resource "azurerm_virtual_network" "devtestlab" {
  name = "Dtldevtestlab1"
  address_space = [
    "10.0.0.0/20",
  ]
  dns_servers         = []
  location            = azurerm_resource_group.devtestlab.location
  resource_group_name = azurerm_resource_group.devtestlab.name

  tags = {
    "hidden-DevTestLabs-LabUId" = "bb66673c-87e4-44f3-a38c-7d877f2773af"
  }
}

resource "azurerm_subnet" "devtestlab" {
  name                                           = "Dtldevtestlab1Subnet"
  address_prefixes                               = ["10.0.0.0/20"]
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
  resource_group_name                            = azurerm_resource_group.devtestlab.name
  service_endpoints                              = []
  virtual_network_name                           = "Dtldevtestlab1"
}

resource "azurerm_storage_account" "devtestlab" {
  name                = "adevtestlab1864"
  location            = azurerm_resource_group.devtestlab.location
  resource_group_name = azurerm_resource_group.devtestlab.name

  access_tier               = "Hot"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  enable_https_traffic_only = true
  is_hns_enabled            = false

  tags = {
    "hidden-DevTestLabs-LabUId" = "bb66673c-87e4-44f3-a38c-7d877f2773af"
  }

  network_rules {
    bypass = [
      "AzureServices",
    ]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_key_vault" "devtestlab" {
  name                            = "devtestlab14469"
  location                        = azurerm_resource_group.devtestlab.location
  resource_group_name             = azurerm_resource_group.devtestlab.name
  tenant_id                       = "9d40ce58-5d33-48b3-bce8-d986adf85c3d"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  purge_protection_enabled        = false
  sku_name                        = "standard"
  soft_delete_enabled             = false
  tags = {
    "CreatedBy"                 = "DevTestLabs"
    "hidden-DevTestLabs-LabUId" = "bb66673c-87e4-44f3-a38c-7d877f2773af"
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_network_security_group" "devtestlab" {
  name                = "${var.prefix}-base-sg"
  location            = azurerm_resource_group.devtestlab.location
  resource_group_name = azurerm_resource_group.devtestlab.name

  security_rule {
    name              = "standard_ports"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "80",
      "443",
      "3389",
      "5985",
      "5986"
    ]
    source_address_prefix      = var.router_wan_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "devtestlab" {
  subnet_id                 = azurerm_subnet.devtestlab.id
  network_security_group_id = azurerm_network_security_group.devtestlab.id
}
