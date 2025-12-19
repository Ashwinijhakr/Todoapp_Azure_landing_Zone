module "rg-prod" {
  source = "../../modules/azurerm_resource_group"

  rgs = var.rg-main
}

module "vnet-prod" {
  source = "../../modules/azurerm_virtual_network"

  vnets = var.vnet-main
  depends_on = [module.rg-prod]
}

module "subnet-prod" {
  source = "../../modules/azurerm_subnet"

  subnets = var.subnet-main
  depends_on = [module.vnet-prod]
}