output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.main.id
}

output "identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = try(azurerm_linux_virtual_machine.main.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = try(azurerm_linux_virtual_machine.main.identity[0].tenant_id, null)
}
