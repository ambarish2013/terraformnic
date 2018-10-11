data "azurerm_subnet" "algo_subnet" {
    name                 = "${var.subnet}"
    virtual_network_name = "${var.vnet}"
    resource_group_name  = "${var.resource_group}"
}

data "null_data_source" "subnet_id" {
    inputs = {
        algo_subnet_id = "${data.azurerm_subnet.algo_subnet.id}"
    }
}
