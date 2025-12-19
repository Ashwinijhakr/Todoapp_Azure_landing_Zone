data "azurerm_network_security_group" "nsg_ids" {
    for_each = var.nic_nsg_association
  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_interface" "nic_ids" {
    for_each = var.nic_nsg_association
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}