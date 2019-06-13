resource "azurerm_virtual_network" "demo" {
  name                = "demo_virtual_network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "azurerm_subnet" "demo" {
  name                 = "demo_subnet"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  virtual_network_name = "${azurerm_virtual_network.demo.name}"
  address_prefix       = "10.0.2.0/24"
}

data "azurerm_public_ip" "demo_vault" {
    name = "${azurerm_public_ip.demo_vault.name}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    depends_on = ["azurerm_virtual_machine.demo_vault"]
}

data "azurerm_public_ip" "demo_consul" {
    name = "${azurerm_public_ip.demo_consul.name}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    depends_on = ["azurerm_virtual_machine.demo_consul"]
}