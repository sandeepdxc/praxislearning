locals {
  common_tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })

  use_ssh_auth    = var.admin_ssh_public_key != null
  enable_identity = var.identity_type != "None"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.main.id]

  disable_password_authentication = local.use_ssh_auth

  dynamic "admin_ssh_key" {
    for_each = local.use_ssh_auth ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_public_key
    }
  }

  admin_password = local.use_ssh_auth ? null : var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_uri
    }
  }

  dynamic "identity" {
    for_each = local.enable_identity ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "SystemAssigned" ? null : var.user_assigned_identity_ids
    }
  }

  custom_data = var.custom_data

  tags = local.common_tags
}
