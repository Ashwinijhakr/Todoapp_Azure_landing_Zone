resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  # ---------- Required Arguments ----------
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method

  # ---------- Optional Arguments ----------
  zones                       = each.value.zones
  sku                         = each.value.sku
  idle_timeout_in_minutes     = each.value.idle_timeout_in_minutes
  ip_tags                     = each.value.ip_tags
  ddos_protection_mode        = each.value.ddos_protection_mode
  ddos_protection_plan_id     = each.value.ddos_protection_plan_id
  reverse_fqdn                = each.value.reverse_fqdn
  domain_name_label           = each.value.domain_name_label
  public_ip_prefix_id         = each.value.public_ip_prefix_id

  # ---------- Tags ----------
  tags = each.value.tags
}
