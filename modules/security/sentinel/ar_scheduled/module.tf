resource "azurerm_sentinel_alert_rule_scheduled" "scheduled" {
  name                       = var.name
  log_analytics_workspace_id = lower(var.log_analytics_workspace_id)
  display_name               = var.display_name
  severity                   = var.severity
  query                      = var.query
  alert_rule_template_guid   = var.alert_rule_template_guid
  description                = var.description
  enabled                    = var.enabled
  query_frequency            = var.query_frequency
  query_period               = var.query_period
  suppression_duration       = var.suppression_duration
  suppression_enabled        = var.suppression_enabled
  tactics                    = var.tactics
  trigger_operator           = var.trigger_operator
  trigger_threshold          = var.trigger_threshold

  dynamic "event_grouping" {
    for_each = lookup(var.settings, "event_grouping", {}) != {} ? [1] : []

    content {
      aggregation_method = lookup(var.settings.event_grouping, "aggregation_method", null)
    }
  }

  dynamic "incident_configuration" {
    for_each = lookup(var.settings, "incident_configuration", {}) != {} ? [1] : []

    content {
      create_incident = lookup(var.settings.incident_configuration, "create_incident", null)

      dynamic "grouping" {
        for_each = lookup(var.settings.incident_configuration, "grouping", {}) != {} ? [1] : []

        content {
          enabled                 = lookup(var.settings.incident_configuration.grouping, "enabled", true)
          lookback_duration       = lookup(var.settings.incident_configuration.grouping, "lookback_duration", "PT5M")
          reopen_closed_incidents = lookup(var.settings.incident_configuration.grouping, "reopen_closed_incidents", false)
          entity_matching_method  = lookup(var.settings.incident_configuration.grouping, "entity_matching_method", null)
          group_by_entities       = lookup(var.settings.incident_configuration.grouping, "group_by_entities", null)
          group_by_alert_details  = lookup(var.settings.incident_configuration.grouping, "group_by_alert_details", null)
          group_by_custom_details = lookup(var.settings.incident_configuration.grouping, "group_by_custom_details", null)
        }
      }
    }
  }

  alert_details_override {
    display_name_format = var.display_name_format
    description_format = null
    tactics_column_name = null
    severity_column_name = null
  }

  dynamic "entity_mapping" {
    for_each = lookup(var.settings, "entityType", {}) != {} ? [1] : []
    content {
      entity_type = lookup(var.settings.entity_mapping, "entityType", null)
      field_mapping {
        identifier  = lookup(var.settings.entity_mapping, "identifier", null)
        column_name = lookup(var.settings.entity_mapping, "columnName", null)
      }
    }
  }
}
