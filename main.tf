provider "azurerm" {
    tenant_id = "${var.tenant_id}"
    client_id = "${var.client_id}"
    subscription_id = "${var.subscription_id}"
    client_secret = "${var.client_secret}"
}

resource "azurerm_resource_group" "demo" {
  name     = "demo_resource_group"
  location = "${var.region}"
}
