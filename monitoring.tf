data "azurerm_monitor_diagnostic_categories" "this" {
  for_each = var.log_analytics_workspace

  resource_id = azurerm_data_factory.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.log_analytics_workspace

  name                           = "monitoring-${var.project}-${var.env}-${var.location}"
  target_resource_id             = azurerm_data_factory.this.id
  log_analytics_workspace_id     = each.value
  log_analytics_destination_type = var.analytics_destination_type

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.this[each.key].log_category_types
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.this[each.key].metrics
    content {
      category = metric.value
    }
  }
}
