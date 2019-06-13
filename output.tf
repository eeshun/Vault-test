output "vault_ip" {
    value = "${data.azurerm_public_ip.demo_vault.ip_address}"
}

output "consul_ip" {
    value = "${data.azurerm_public_ip.demo_consul.ip_address}"
}

output "database_fqdn" {
    value = "${azurerm_sql_server.test.fully_qualified_domain_name}"
}
