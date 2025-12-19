variable "rgs" {
  type = map(object({
    name       = string                #name of the resource group
    location   = string                #location of the resource group
    managed_by = optional(string)      #who is managing the resource group
    tags       = optional(map(string)) #tag for specifying the project,owner,cost etc
  }))
}

variable "stgs" {
  description = "Map of storage accounts configuration"
  type = map(object({
    # ---------- Required ----------
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string

    # ---------- Optional ----------

    account_kind                      = optional(string)
    provisioned_billing_model_version = optional(string)
    cross_tenant_replication_enabled  = optional(bool)
    access_tier                       = optional(string)
    edge_zone                         = optional(string)
    https_traffic_only_enabled        = optional(bool)
    min_tls_version                   = optional(string)
    allow_nested_items_to_be_public   = optional(bool)
    shared_access_key_enabled         = optional(bool)
    public_network_access_enabled     = optional(bool)
    default_to_oauth_authentication   = optional(bool)
    is_hns_enabled                    = optional(bool)
    nfsv3_enabled                     = optional(bool)
    large_file_share_enabled          = optional(bool)
    local_user_enabled                = optional(bool)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    infrastructure_encryption_enabled = optional(bool)
    sftp_enabled                      = optional(bool)
    dns_endpoint_type                 = optional(string)
    allowed_copy_scope                = optional(string)
    tags                              = optional(map(string))
    network_rules = optional(list(object({
      default_action = string
      bypass         = optional(list(string))
      ip_rules       = optional(list(string))
    })), [])
  }))
}

variable "vnets" {
  description = "Map of Virtual Network configurations"
  type = map(object({
    name                    = string
    resource_group_name     = string
    location                = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    bgp_community           = optional(string)
    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))

    ddos_protection_plan = optional(list(object({
      id     = string
      enable = bool
    })), [])

    subnets = optional(list(object({
      name                                          = string
      address_prefix                                = list(string)
      service_endpoints                             = optional(list(string))
      private_endpoint_network_policies             = optional(bool)
      private_link_service_network_policies_enabled = optional(bool)
      delegation = optional(list(object({
        name = string
        service_delegation = object({
          name    = string
          actions = list(string)
        })
      })), [])
    })), [])
  }))
}


variable "pips" {
  description = "Map of public IP configurations"
  type = map(object({
    name                    = string
    location                = string
    resource_group_name     = string
    allocation_method       = string
    zones                   = optional(list(string))
    sku                     = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    reverse_fqdn            = optional(string)
    domain_name_label       = optional(string)
    public_ip_prefix_id     = optional(string)
    tags                    = optional(map(string))
  }))
}


# Network Security Group (NSG)
variable "nsgs" {
  description = "Map of Network Security Group configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string))

    security_rules = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = optional(string)
      destination_port_range       = optional(string)
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_ranges      = optional(list(string))
      source_address_prefixes      = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })), [])
  }))
}

# Network Interface (NIC)
variable "nics" {
  description = "Map of Network Interface configurations"
  type = map(object({
    # data block variable
    vnet_name   = string
    subnet_name = string
    pip_name    = string
    # resource block variable
    name                          = string
    resource_group_name           = string
    location                      = string
    enable_ip_forwarding          = optional(bool)
    enable_accelerated_networking = optional(bool)
    tags                          = optional(map(string))

    ip_configurations = optional(list(object({
      name = string
      # subnet_id                     = string # if we using data block for this then not required here
      private_ip_address_allocation = string
      private_ip_address_version    = optional(string)
      public_ip_address_id          = optional(string)
      primary                       = optional(bool)
    })), [])
  }))
}

# NIC ↔ NSG Association
variable "nic_nsg_association" {
  description = "Map defining NIC and NSG association"
  type = map(object({
    # data block variable
    nic_name            = string
    nsg_name            = string
    resource_group_name = string
    # resource block variable  # if we using data block for this then not required here
    # network_interface_id      = string
    # network_security_group_id = string
  }))
}

# Virtual Machine (Linux)
variable "vms" {
  description = "Map of Linux Virtual Machine configurations"
  type = map(object({
    # data block variable
    nic_name                = string
    kv_name                 = string
    vm_username_secret_name = string
    vm_password_secret_name = string
    # resource block variable
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    # costom_data script_name
    script_name = string
    # admin_username                  = string           # value taken from key vault secret
    # admin_password                  = optional(string) # value taken from key vault secret
    # network_interface_ids           = list(string)     # if we using data block for this then not required here
    disable_password_authentication = optional(bool)
    computer_name                   = optional(string)
    custom_data                     = optional(string)
    provision_vm_agent              = optional(bool)
    allow_extension_operations      = optional(bool)
    edge_zone                       = optional(string)
    encryption_at_host_enabled      = optional(bool)
    patch_mode                      = optional(string)
    reboot_setting                  = optional(string)
    secure_boot_enabled             = optional(bool)
    vtpm_enabled                    = optional(bool)
    tags                            = optional(map(string))
    zone                            = optional(string)

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    os_disk = optional(list(object({
      name                 = string
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
    })), [])

    admin_ssh_key = optional(list(object({
      username   = string
      public_key = string
    })), [])

    boot_diagnostics = optional(list(object({
      storage_account_uri = string
    })), [])
  }))
}

variable "key_vaults" {
  description = "Map of Azure Key Vault configurations"
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    sku_name                        = string
    tenant_id                       = optional(string)
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

variable "kv_secrets" {

  type = map(object({
    # Required
    kv_name     = string
    rg_name     = string
    secret_name = string

    # Optional values (exactly one must be defined)
    secret_value            = optional(string)
    secret_value_wo         = optional(string)
    secret_value_wo_version = optional(number)

    # Optional metadata
    content_type    = optional(string)
    not_before_date = optional(string)
    expiration_date = optional(string)
    tags            = optional(map(string))
  }))
}

variable "sql_databases" {
  description = "Map of Azure MSSQL Database configurations"
  type = map(object({
    # ---------- Required ----------
    name                = string
    resource_group_name = string
    location            = string
    server_name         = string

    # ---------- Optional simple arguments ----------
    sku_name                                                   = optional(string)
    collation                                                  = optional(string)
    max_size_gb                                                = optional(number)
    min_capacity                                               = optional(number)
    zone_redundant                                             = optional(bool)
    license_type                                               = optional(string)
    read_replica_count                                         = optional(number)
    geo_backup_enabled                                         = optional(bool)
    transparent_data_encryption_enabled                        = optional(bool)
    transparent_data_encryption_key_vault_key_id               = optional(string)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
    ledger_enabled                                             = optional(bool)
    read_scale                                                 = optional(bool)
    sample_name                                                = optional(string)
    storage_account_type                                       = optional(string)
    enclave_type                                               = optional(string)
    maintenance_configuration_name                             = optional(string)
    secondary_type                                             = optional(string)
    creation_source_database_id                                = optional(string)
    create_mode                                                = optional(string)
    restore_point_in_time                                      = optional(string)
    recover_database_id                                        = optional(string)
    recovery_point_id                                          = optional(string)
    restore_dropped_database_id                                = optional(string)
    restore_long_term_retention_backup_id                      = optional(string)
    elastic_pool_id                                            = optional(string)
    auto_pause_delay_in_minutes                                = optional(number)
    tags                                                       = optional(map(string))

    # ---------- Optional Import Block ----------
    import = optional(list(object({
      storage_uri                  = string
      storage_key                  = string
      storage_key_type             = string
      administrator_login          = string
      administrator_login_password = string
      authentication_type          = string
      storage_account_id           = optional(string)
    })), [])

    # ---------- Optional Threat Detection Policy ----------
    threat_detection_policy = optional(list(object({
      state                      = optional(string)
      disabled_alerts            = optional(list(string))
      email_account_admins       = optional(bool)
      email_addresses            = optional(list(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    })), [])

    # ---------- Optional Short-Term Retention Policy ----------
    short_term_retention_policy = optional(list(object({
      retention_days           = number
      backup_interval_in_hours = optional(number)
    })), [])

    # ---------- Optional Long-Term Retention Policy ----------
    long_term_retention_policy = optional(list(object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(number)
    })), [])

    # ---------- Optional Identity ----------
    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(string))
    })), [])
  }))
}


variable "sql_servers" {
  description = "Map of Azure SQL Server configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    version             = string
    # data block variable
    kv_name                  = string
    sql_username_secret_name = string
    sql_password_secret_name = string
    # administrator_login                        = optional(string)    # value taken from key vault secret
    # administrator_login_password               = optional(string)    # value taken from key vault secret
    administrator_login_password_wo              = optional(string)
    administrator_login_password_wo_version      = optional(number)
    connection_policy                            = optional(string)
    express_vulnerability_assessment_enabled     = optional(bool)
    transparent_data_encryption_key_vault_key_id = optional(string)
    minimum_tls_version                          = optional(string)
    public_network_access_enabled                = optional(bool)
    outbound_network_restriction_enabled         = optional(bool)
    primary_user_assigned_identity_id            = optional(string)

    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(string))
    })), [])

    azuread_administrator = optional(list(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool)
    })), [])

    tags = optional(map(string))
  }))
}




