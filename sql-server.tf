resource "azurerm_sql_server" "test" {
    name = "mysqlserver-demo20180204" 
    resource_group_name = "${azurerm_resource_group.demo.name}"
    location = "${var.region}"
    version = "12.0"
    administrator_login = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "test" {
  name                = "mysqldatabase"
  resource_group_name = "${azurerm_resource_group.demo.name}"
    location = "${var.region}"
    server_name = "${azurerm_sql_server.test.name}"

  tags {
    environment = "production"
  }
}

resource "azurerm_sql_firewall_rule" "test" {
  name                = "FirewallRule1"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  server_name         = "${azurerm_sql_server.test.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}