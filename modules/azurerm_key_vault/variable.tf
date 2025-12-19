variable "key_vaults" {
  description = "Map of Azure Key Vault configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
    tenant_id           = optional(string)
    enabled_for_deployment          = optional(bool)
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_template_deployment = optional(bool)
    purge_protection_enabled        = optional(bool)
    soft_delete_retention_days      = optional(number)

    access_policies = optional(list(object({
      # tenant_id               = string    # if we using data block for this then not required here
      # object_id               = string    # if we using data block for this then not required here
      application_id          = optional(string)
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      certificate_permissions = optional(list(string))
      storage_permissions     = optional(list(string))
    })), [])

    tags = optional(map(string))
  }))
}
