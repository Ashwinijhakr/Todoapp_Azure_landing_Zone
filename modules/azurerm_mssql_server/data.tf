data "azurerm_key_vault" "kv" {
  for_each = var.sql_servers
  name                = each.value.kv_name
  resource_group_name = each.value.resource_group_name
  
  }

  data "azurerm_key_vault_secret" "sql_admin_username" {
  for_each = var.sql_servers
  name         = each.value.sql_username_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  for_each = var.sql_servers
  name         = each.value.sql_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}