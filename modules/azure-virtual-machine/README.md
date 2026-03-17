# Azure Virtual Machine Module

Creates an Azure Virtual Machine with network interface, optional public IP, and data disks.

## Features

- Supports both Linux and Windows VMs
- Optional public IP address
- Configurable data disks
- Boot diagnostics support
- Flexible VM sizing
- Consistent tagging

## Usage

### Linux VM with SSH Key

```hcl
module "vm" {
  source = "./modules/azure-virtual-machine"

  name                = "my-linux-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.main.id

  os_type              = "linux"
  admin_username       = "adminuser"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")

  enable_public_ip = true

  tags = {
    Environment = "dev"
  }
}
```

### Windows VM

```hcl
module "vm" {
  source = "./modules/azure-virtual-machine"

  name                = "my-windows-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.main.id

  os_type        = "windows"
  admin_username = "adminuser"
  admin_password = var.admin_password

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  vm_size = "Standard_D2s_v3"
}
```

### VM with Data Disks

```hcl
module "vm" {
  source = "./modules/azure-virtual-machine"

  name                = "my-db-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.main.id

  os_type              = "linux"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
  vm_size              = "Standard_E4s_v3"
  os_disk_type         = "Premium_LRS"

  data_disks = [
    {
      name         = "data"
      size_gb      = 256
      storage_type = "Premium_LRS"
      lun          = 0
    },
    {
      name         = "logs"
      size_gb      = 128
      storage_type = "Standard_LRS"
      lun          = 1
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for all resources | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| subnet_id | Subnet ID for the NIC | `string` | n/a | yes |
| vm_size | VM size | `string` | `"Standard_B2s"` | no |
| os_type | OS type (linux/windows) | `string` | `"linux"` | no |
| source_image_reference | Source image for the VM | `object` | Ubuntu 22.04 LTS | no |
| admin_username | Admin username | `string` | `"adminuser"` | no |
| admin_password | Admin password (Windows) | `string` | `null` | no |
| admin_ssh_public_key | SSH public key (Linux) | `string` | `null` | no |
| os_disk_size_gb | OS disk size in GB | `number` | `30` | no |
| os_disk_type | OS disk type | `string` | `"Standard_LRS"` | no |
| data_disks | List of data disks | `list(object)` | `[]` | no |
| enable_public_ip | Create public IP | `bool` | `false` | no |
| public_ip_allocation_method | Public IP allocation | `string` | `"Static"` | no |
| enable_boot_diagnostics | Enable boot diagnostics | `bool` | `true` | no |
| boot_diagnostics_storage_uri | Storage URI for diagnostics | `string` | `null` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | Virtual machine ID |
| vm_name | Virtual machine name |
| private_ip_address | Private IP address |
| public_ip_address | Public IP (if enabled) |
| network_interface_id | Network interface ID |
| admin_username | Admin username |
| data_disk_ids | Map of data disk IDs |
