locals {
  endpoint = {
    for target, values in var.managed_private_endpoint : "${target.name}-${var.env}" => values
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each = local.endpoint

  name               = each.key
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.target_resource_id
  subresource_name   = each.value.subresource_name
}

data "azapi_resource" "this" {
  for_each = { for i in var.managed_private_endpoint : i.name => i }

  type                   = each.value.type
  resource_id            = each.value.subresource_name == "dfs" ? var.storage_account_id : each.value.target_resource_id
  response_export_values = ["properties.privateEndpointConnections"]

  depends_on = [
    azurerm_data_factory_managed_private_endpoint.this
  ]
}

# Adls
resource "azapi_update_resource" "adls" {
  for_each = { for i in var.managed_private_endpoint : i.name => i if i.type == "Microsoft.Storage/storageAccounts@2023-01-01" }

  name = one([
    for connection in jsondecode(data.azapi_resource.this[each.key].output).properties.privateEndpointConnections
    : connection.name
    if
    endswith(connection.properties.privateLinkServiceConnectionState.description, "${each.key}-${var.env}")
  ])
  type      = "Microsoft.Storage/storageAccounts/privateEndpointConnections@2023-01-01"
  parent_id = each.value.subresource_name == "dfs" ? var.storage_account_id : each.value.target_resource_id

  body = jsonencode({
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform ${azurerm_data_factory_managed_private_endpoint.this["${each.key}-dev"].name}"
        status      = "Approved"
      }
    }
  })

  lifecycle {
    ignore_changes = all
  }
}

# key vault
resource "azapi_update_resource" "keyvault_approval" {
  for_each = { for i in var.managed_private_endpoint : i.name => i if i.type == "Microsoft.KeyVault/vaults@2022-07-01" }

  name = "${basename([for connection in [for connection in jsondecode(data.azapi_resource.this[each.key].output).properties.privateEndpointConnections : connection]
  : connection.properties.privateEndpoint.id][0])}-conn"
  type      = "Microsoft.KeyVault/vaults/privateEndpointConnections@2022-07-01"
  parent_id = each.value.target_resource_id

  body = jsonencode({
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform, azapi_update_resource."
        status      = "Approved"
      }
    }
  })

  lifecycle {
    ignore_changes = all
  }
}

# Databricks workspace 
resource "azapi_update_resource" "databricks_approval" {
  for_each = { for i in var.managed_private_endpoint : i.name => i if i.type == "Microsoft.Databricks/workspaces@2023-02-01" }

  name = "${basename([for i in [for connection in [for connection in jsondecode(data.azapi_resource.this[each.key].output).properties.privateEndpointConnections : connection]
  : connection.properties.privateEndpoint.id] : i if strcontains(i, "adf")][0])}-conn"
  type      = "Microsoft.Databricks/workspaces/privateEndpointConnections@2023-02-01"
  parent_id = each.value.target_resource_id

  body = jsonencode({
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform, azapi_update_resource."
        status      = "Approved"
      }
    }
  })

  lifecycle {
    ignore_changes = all
  }
}
