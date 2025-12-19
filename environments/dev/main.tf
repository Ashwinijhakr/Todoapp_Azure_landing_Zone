module "rg" {
  source = "../../modules/azurerm_resource_group"

  rgs = var.rgs
}


module "stg" {
  source = "../../modules/azurerm_storage_account"

  stgs       = var.stgs
  depends_on = [module.rg]
}



module "vnet" {
  source = "../../modules/azurerm_virtual_network"

  vnets      = var.vnets
  depends_on = [module.rg]
}

module "pip" {
  source = "../../modules/azurerm_public_ip"

  public_ips = var.pips
  depends_on = [module.rg]
}

module "nsg" {
  source = "../../modules/azurerm_network_security_group"

  nsgs       = var.nsgs
  depends_on = [module.rg]
}

module "nic" {
  source = "../../modules/azurerm_network_interface"

  nics       = var.nics
  depends_on = [module.rg, module.pip, module.vnet]
}

module "nic_nsg_association" {
  depends_on          = [module.nic, module.nsg]
  nic_nsg_association = var.nic_nsg_association
  source              = "../../modules/azurerm_nic_nsg_association"
}

module "vm" {
  source = "../../modules/azurerm_linux_virtual_machine"

  vms        = var.vms
  depends_on = [module.rg, module.nic, module.key_vault_secret, module.key_vault]
}

module "key_vault" {
  source = "../../modules/azurerm_key_vault"

  key_vaults = var.key_vaults
  depends_on = [module.rg]
}

module "key_vault_secret" {
  source     = "../../modules/azurerm_key_vault_secret"
  kv_secrets = var.kv_secrets
  depends_on = [module.key_vault]
}

module "mssql_server" {
  source = "../../modules/azurerm_mssql_server"

  sql_servers = var.sql_servers
  depends_on  = [module.rg, module.key_vault_secret, module.key_vault]
}
module "mssql_database" {
  source = "../../modules/azurerm_mssql_database"

  sql_databases = var.sql_databases
  depends_on    = [module.mssql_server]
}