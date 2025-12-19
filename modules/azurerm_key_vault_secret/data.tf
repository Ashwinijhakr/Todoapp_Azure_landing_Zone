data "azurerm_key_vault" "key_vault" {
  for_each =  var.kv_secrets
  name                = each.value.kv_name
  resource_group_name = each.value.rg_name
}