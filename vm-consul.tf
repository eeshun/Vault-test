resource "azurerm_public_ip" "demo_consul" {
  name                         = "demo_public_ip_consul"
  location                     = "${var.region}"
  resource_group_name          = "${azurerm_resource_group.demo.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "demo_consul" {
  name                = "demo_nic_consul"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  ip_configuration {
    name                          = "demo_ipconfig_consul"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.demo_consul.id}"
  }
  
tags {
      ConsulDC = "consul-demo"
  }

}

resource "azurerm_virtual_machine" "demo_consul" {
  name                  = "demo_vm_consul"
  location              = "${var.region}"
  resource_group_name   = "${azurerm_resource_group.demo.name}"
  network_interface_ids = ["${azurerm_network_interface.demo_consul.id}"]
  vm_size               = "Standard_D1"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1_consul"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_consul"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "demo-consul"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    custom_data    = "${data.template_file.init-consul.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
      ConsulDC = "consul-demo"
  }
}

data "template_file" "init-consul" {
  template = "${file("${path.module}/templates/custom-data-consul.tpl")}"

  vars {
    tpl_autojoin_tenant_id = "${var.autojoin_tenant_id}"
    tpl_autojoin_client_id = "${var.autojoin_client_id}"
    tpl_autojoin_subscription_id = "${var.autojoin_subscription_id}"
    tpl_autojoin_secret_access_key = "${var.autojoin_secret_access_key}"
    tpl_consul_zip_file = "${var.consul_zip_file}"  
    }
}