variable "name" {
  description = "Name of the virtual machine"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "VM name must be between 1 and 64 characters."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "size" {
  description = "Size of the virtual machine (e.g., Standard_B2s, Standard_D2s_v3)"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for authentication"
  type        = string
  default     = null
}

variable "admin_password" {
  description = "Administrator password (used if SSH key not provided)"
  type        = string
  default     = null
  sensitive   = true
}

variable "subnet_id" {
  description = "Subnet ID where the VM NIC will be attached"
  type        = string
}

variable "source_image_reference" {
  description = "Source image reference for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
}

variable "os_disk_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Standard_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_type)
    error_message = "OS disk type must be Standard_LRS, StandardSSD_LRS, or Premium_LRS."
  }
}

variable "enable_boot_diagnostics" {
  description = "Enable boot diagnostics"
  type        = bool
  default     = true
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage account URI for boot diagnostics (null for managed storage)"
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Type of managed identity (None, SystemAssigned, UserAssigned, SystemAssigned_UserAssigned)"
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["None", "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Identity type must be None, SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "user_assigned_identity_ids" {
  description = "List of user-assigned managed identity IDs"
  type        = list(string)
  default     = []
}

variable "custom_data" {
  description = "Custom data (cloud-init) script in base64 encoding"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
