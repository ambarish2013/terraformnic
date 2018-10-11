# Create public IPs
resource "azurerm_public_ip" "algo_vm_publicip" {
    name                         = "algo_vm_publicip"
    location                     = "${var.region}"
    resource_group_name          = "${var.resource_group}"
    public_ip_address_allocation = "dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "algo_vm_nsg" {
    name                = "algo_vm_nsg"
    location            = "${var.region}"
    resource_group_name = "${var.resource_group}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "algo_vm_nic" {
    name                      = "algo_vm_nic"
    location                  = "${var.region}"
    resource_group_name       = "${var.resource_group}"
    network_security_group_id = "${azurerm_network_security_group.algo_vm_nsg.id}"

    ip_configuration {
        name                          = "algo_vm_nic_config"
        subnet_id                     = "${data.null_data_source.subnet_id.outputs["algo_subnet_id"]}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.algo_vm_publicip.id}"
    }
}

output "algo_vm_nic_id" {
    value = "${azurerm_network_interface.algo_vm_nic.id}"
}
