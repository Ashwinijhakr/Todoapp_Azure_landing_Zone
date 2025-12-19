resource "azurerm_mssql_server" "sql_servers" {
  for_each = var.sql_servers

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  version             = each.value.version
  # Secure credentials from Key Vault
  administrator_login          = data.azurerm_key_vault_secret.sql_admin_username[each.key].value
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_password[each.key].value

  administrator_login_password_wo              = each.value.administrator_login_password_wo
  administrator_login_password_wo_version      = each.value.administrator_login_password_wo_version
  connection_policy                            = each.value.connection_policy
  express_vulnerability_assessment_enabled     = each.value.express_vulnerability_assessment_enabled
  transparent_data_encryption_key_vault_key_id = each.value.transparent_data_encryption_key_vault_key_id
  minimum_tls_version                          = each.value.minimum_tls_version
  public_network_access_enabled                = each.value.public_network_access_enabled
  outbound_network_restriction_enabled         = each.value.outbound_network_restriction_enabled
  primary_user_assigned_identity_id            = each.value.primary_user_assigned_identity_id

  # Optional identity block
  dynamic "identity" {
    for_each = each.value.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Optional Azure AD Administrator block
  dynamic "azuread_administrator" {
    for_each = each.value.azuread_administrator
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  tags = each.value.tags
}
