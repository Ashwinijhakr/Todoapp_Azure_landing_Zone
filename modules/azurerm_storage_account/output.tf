output "stg_ids" {
  value = { for k, v in azurerm_storage_account.stg : k => v.id }
}
