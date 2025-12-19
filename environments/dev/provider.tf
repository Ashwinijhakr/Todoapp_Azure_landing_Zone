terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
     version = ">= 3.90.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name   = "ashwRg"
  #   storage_account_name  = "storage55"
  #   container_name        = "tfstate"
  #   key                   = "dev.terraform.tfstate"

  # }
}

provider "azurerm" {
  features {}
  subscription_id = "a201d6ce-420d-42ed-93d7-34c69de03add"
}