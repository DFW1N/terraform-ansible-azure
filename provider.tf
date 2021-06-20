# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}


# Using Terraform Workspace:
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "organization-value-id"

    workspaces {
      name = "workstation-value-id"
    }
  }
}

# Using Azure Storage Container to store state file instead of remote backend from terraform

/*terraform {
  backend "azurerm" {
    resource_group_name  = "Resource-Group-Name-Value"
    storage_account_name = "Account-Name-Value"
    container_name       = "tfstate"
    key                  = "00000000-0000-0000-0000-000000000000"
  }
}*/
