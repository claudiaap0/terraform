terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "dbe857d8-f7ea-4c79-bb59-b4e5bc080426"
}

data "azurerm_client_config" "current" {}
