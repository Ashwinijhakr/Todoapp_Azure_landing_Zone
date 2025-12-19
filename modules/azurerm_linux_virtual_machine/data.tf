data "azurerm_network_interface" "nic_ids" {
    for_each = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault" "kv" {
  for_each = var.vms
  name                = each.value.kv_name
  resource_group_name = each.value.resource_group_name
  
  }

  data "azurerm_key_vault_secret" "vm_admin_username" {
  for_each = var.vms
  name         = each.value.vm_username_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  for_each = var.vms
  name         = each.value.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}