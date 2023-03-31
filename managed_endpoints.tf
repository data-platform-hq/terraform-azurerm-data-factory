locals {
  endpoint = {
    for target, values in var.managed_private_endpoint : "${target}-${var.env}" => values
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each = local.endpoint
  #   for_each = var.managed_private_endpoint

  name               = each.key
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.target_resource_id
  subresource_name   = each.value.subresource_name
}
