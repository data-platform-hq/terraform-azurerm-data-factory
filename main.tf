locals {
  adf_name  = var.custom_adf_name == null ? "adf-${var.project}-${var.env}-${var.location}" : var.custom_adf_name
  ir_name   = var.custom_default_ir_name == null ? "DefaultAutoResolve" : var.custom_default_ir_name
  shir_name = var.custom_shir_name == null ? "shir-${var.project}-${var.env}-${var.location}" : var.custom_shir_name
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

  dynamic "global_parameter" {
    for_each = { for i in var.global_parameter : i.name => i if i.name != null }

    content {
      name  = global_parameter.value.name
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
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

  lifecycle {
    ignore_changes = [
      global_parameter,
    ]
  }
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

resource "azurerm_data_factory_integration_runtime_self_hosted" "this" {
  count = var.self_hosted_integration_runtime_enabled ? 1 : 0

  name            = local.shir_name
  data_factory_id = azurerm_data_factory.this.id
}
