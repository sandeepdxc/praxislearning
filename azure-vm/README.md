# Azure Linux Virtual Machine Module

Creates an Azure Linux VM with optional boot diagnostics, managed identity, and cloud-init support.

## Usage

```hcl
module "vm" {
  source = "./azure-vm"

  name                = "my-vm"
  resource_group_name = "my-rg"
  location            = "eastus"
  subnet_id           = "/subscriptions/.../subnets/default"

  admin_username       = "azureuser"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")

  size         = "Standard_B2s"
  os_disk_type = "StandardSSD_LRS"

  enable_boot_diagnostics = true
  identity_type           = "SystemAssigned"

  tags = {
    Environment = "dev"
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
| name | VM name | string | n/a | yes |
| resource_group_name | Resource group name | string | n/a | yes |
| location | Azure region | string | n/a | yes |
| subnet_id | Subnet ID for NIC | string | n/a | yes |
| size | VM size | string | "Standard_B2s" | no |
| admin_username | Admin username | string | "azureuser" | no |
| admin_ssh_public_key | SSH public key | string | null | no |
| admin_password | Admin password | string | null | no |
| os_disk_size_gb | OS disk size | number | 30 | no |
| os_disk_type | OS disk type | string | "Standard_LRS" | no |
| enable_boot_diagnostics | Enable boot diagnostics | bool | true | no |
| identity_type | Managed identity type | string | "SystemAssigned" | no |
| custom_data | Cloud-init script (base64) | string | null | no |
| tags | Resource tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | Virtual machine ID |
| vm_name | Virtual machine name |
| private_ip_address | Private IP address |
| network_interface_id | NIC ID |
| identity_principal_id | System identity principal ID |
| identity_tenant_id | System identity tenant ID |

## Features

- **Boot Diagnostics**: Enabled by default with managed storage
- **Managed Identity**: SystemAssigned by default for Azure resource access
- **Cloud-init Support**: Pass custom_data for initialization scripts
- **Flexible Authentication**: SSH key or password authentication
- **Configurable OS Disk**: Size and storage type options
