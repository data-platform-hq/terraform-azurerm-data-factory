locals {
  key_vault_resource_group = var.key_vault_resource_group == "" ? var.resource_group : var.key_vault_resource_group
  adf_name                 = var.custom_adf_name == null ? "adf-${var.project}-${var.env}-${var.location}" : var.custom_adf_name
  ir_name                  = var.custom_default_ir_name == null ? "DefaultAutoResolve" : var.custom_default_ir_name
}

data "azurerm_key_vault" "this" {
  count = length(var.key_vault_name) == 0 ? 0 : 1

  name                = var.key_vault_name
  resource_group_name = local.key_vault_resource_group
}

resource "azurerm_data_factory" "this" {
  name                            = local.adf_name
  location                        = var.location
  resource_group_name             = var.resource_group
  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }

  global_parameter {
    name  = "environment"
    type  = "String"
    value = var.env
  }

  dynamic "vsts_configuration" {
    for_each = length(var.vsts_configuration) == 0 ? [] : [var.vsts_configuration]

    content {
      account_name    = var.vsts_configuration.account_name
      branch_name     = var.vsts_configuration.branch_name
      project_name    = var.vsts_configuration.project_name
      repository_name = var.vsts_configuration.repository_name
      root_folder     = var.vsts_configuration.root_folder
      tenant_id       = var.vsts_configuration.tenant_id
    }
  }
}

resource "azurerm_key_vault_access_policy" "this" {
  count = length(var.key_vault_name) == 0 ? 0 : 1

  key_vault_id = data.azurerm_key_vault.this[0].id

  tenant_id = azurerm_data_factory.this.identity[0].tenant_id
  object_id = azurerm_data_factory.this.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_data_factory_linked_service_key_vault" "this" {
  count           = length(var.key_vault_name) == 0 ? 0 : 1
  name            = "key-vault"
  data_factory_id = azurerm_data_factory.this.id
  key_vault_id    = data.azurerm_key_vault.this[0].id
}

resource "azurerm_role_assignment" "data_factory" {
  for_each = {
    for permission in var.permissions : "${permission.object_id}-${permission.role}" => permission
    if permission.role != null
  }
  scope                = azurerm_data_factory.this.id
  role_definition_name = each.value.role
  principal_id         = each.value.object_id
}

resource "azurerm_data_factory_integration_runtime_azure" "auto_resolve" {
  data_factory_id         = azurerm_data_factory.this.id
  location                = "AutoResolve"
  name                    = local.ir_name
  time_to_live_min        = var.time_to_live_min
  virtual_network_enabled = var.virtual_network_enabled
  cleanup_enabled         = var.cleanup_enabled
  compute_type            = var.compute_type
  core_count              = var.core_count
}
