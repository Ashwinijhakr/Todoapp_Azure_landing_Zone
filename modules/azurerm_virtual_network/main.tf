resource "azurerm_virtual_network" "vnet" {

  for_each = var.vnets

  # ---------- Required Arguments ----------
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

  # ---------- Optional Arguments ----------
  dns_servers             = each.value.dns_servers
  bgp_community           = each.value.bgp_community
  edge_zone               = each.value.edge_zone
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes
  tags                    = each.value.tags

  # ---------- Optional Nested Block ----------
  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_protection_plan
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  # ---------- Optional Nested Block ----------
  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name           = subnet.value.name
      address_prefixes = subnet.value.address_prefix
      service_endpoints = subnet.value.service_endpoints
      private_endpoint_network_policies     = subnet.value.private_endpoint_network_policies
      private_link_service_network_policies_enabled = subnet.value.private_link_service_network_policies_enabled

      # ---------- Optional Nested Block ----------
      dynamic "delegation" {
        for_each = subnet.value.delegation
        content {
          name = delegation.value.name
          service_delegation {
            name    = delegation.value.service_delegation.name
            actions = delegation.value.service_delegation.actions
          }
        }
      }
    }
  }
}
