# Network Interface (NIC)
resource "azurerm_network_interface" "nic" {

  for_each = var.nics
  
  # ---------- Required Arguments ----------
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  # ---------- Optional Arguments ----------
  ip_forwarding_enabled         = each.value.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  tags                          = each.value.tags

  # ---------- Optional Nested Block ----------
  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnet_ids[each.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = ip_configuration.value.private_ip_address_version
      public_ip_address_id          = data.azurerm_public_ip.pip_ids[each.key].id
      primary                       = ip_configuration.value.primary
    }
  }
}