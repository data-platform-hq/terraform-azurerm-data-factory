output "id" {
  value       = azurerm_data_factory.this.id
  description = "Data Factory ID"
}

output "name" {
  value       = azurerm_data_factory.this.name
  description = "Data Factory Name"
}

output "identity" {
  value       = azurerm_data_factory.this.identity[*]
  description = "Data Factory Managed Identity"
}

output "linked_service_key_vault_name" {
  value       = azurerm_data_factory_linked_service_key_vault.this[0].name
  description = "Data Factory Linked Service Key Vault Name"
}

output "default_integration_runtime_name" {
  value       = azurerm_data_factory_integration_runtime_azure.auto_resolve.name
  description = "Data Factory Default Integration Runtime Name"
}

output "self_hosted_integration_runtime_key" {
  value       = try(azurerm_data_factory_integration_runtime_self_hosted.this[0].primary_authorization_key, null)
  description = "Self hosted integration runtime primary authorization key"
}
