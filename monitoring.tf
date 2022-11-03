resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = { for k, v in var.log_analytics_workspace : k => v }


  name                           = "monitoring-${var.project}-${var.env}-${var.location}"
  target_resource_id             = azurerm_data_factory.this.id
  log_analytics_workspace_id     = each.value
  log_analytics_destination_type = var.destination_type


  dynamic "log" {
    for_each = var.log_category_list
    content {
      category = log.value
      enabled  = true

      retention_policy {
        days    = var.log_retention_days
        enabled = true
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = var.metric_retention_days
      enabled = true
    }
  }

  depends_on = [azurerm_data_factory.this]
}
