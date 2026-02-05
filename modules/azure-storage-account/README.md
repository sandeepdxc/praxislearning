# Azure Storage Account Module

Terraform module to create an Azure Storage Account with configurable settings.

## Usage

```hcl
module "storage" {
  source = "./modules/azure-storage-account"

  name                     = "mystorageaccount123"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_replication_type = "LRS"

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Storage account name (3-24 chars, lowercase alphanumeric) | string | n/a | **yes** |
| resource_group_name | Resource group name | string | n/a | **yes** |
| location | Azure region | string | n/a | **yes** |
| account_tier | Storage tier (Standard, Premium) | string | "Standard" | no |
| account_replication_type | Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS) | string | "LRS" | no |
| account_kind | Account kind (StorageV2, Storage, BlobStorage) | string | "StorageV2" | no |
| access_tier | Access tier (Hot, Cool) | string | "Hot" | no |
| enable_https_traffic_only | Enforce HTTPS | bool | true | no |
| min_tls_version | Minimum TLS version | string | "TLS1_2" | no |
| allow_nested_items_to_be_public | Allow public blob access | bool | false | no |
| tags | Tags to apply | map(string) | {} | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| id | Storage account ID | no |
| name | Storage account name | no |
| primary_location | Primary location | no |
| primary_blob_endpoint | Blob service endpoint | no |
| primary_queue_endpoint | Queue service endpoint | no |
| primary_table_endpoint | Table service endpoint | no |
| primary_file_endpoint | File service endpoint | no |
| primary_access_key | Primary access key | **yes** |
| secondary_access_key | Secondary access key | **yes** |
| primary_connection_string | Connection string | **yes** |

## Security Defaults

This module enforces security best practices by default:
- HTTPS traffic only enabled
- Minimum TLS version set to 1.2
- Public blob access disabled

## Example with Resource Group

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-storage-example"
  location = "East US"
}

module "storage" {
  source = "./modules/azure-storage-account"

  name                = "examplestorageacc"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

output "storage_account_id" {
  value = module.storage.id
}

output "blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}
```
