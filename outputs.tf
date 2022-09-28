output "id" {
  value = azurerm_data_factory.this.id
}

output "name" {
  value = azurerm_data_factory.this.name
}

output "identity" {
  value = azurerm_data_factory.this.identity.*
}

output "linked_service_key_vault_name" {
  value = azurerm_data_factory_linked_service_key_vault.this[0].name
}

output "default_integration_runtime_name" {
  value = azurerm_data_factory_integration_runtime_azure.auto_resolve.name
}
