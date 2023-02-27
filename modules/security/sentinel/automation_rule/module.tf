resource "azurerm_sentinel_automation_rule" "automation_rule" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  order                      = var.order
  enabled                    = var.enabled
  expiration                 = var.expiration

  dynamic "action_incident" {
    for_each = try(var.settings.action_incident, {})

    content {
      order                  = try(action_incident.value.order, null)
      status                 = try(action_incident.value.status, null)
      classification         = try(action_incident.value.classification, null)
      classification_comment = try(action_incident.value.classification_comment, null)
      labels                 = try(action_incident.value.labels, null)
      owner_id               = try(action_incident.value.owner_id, null)
      severity               = try(action_incident.value.severity, null)
    }
  }

  dynamic "action_playbook" {
    for_each = var.action_order == null ? [] : var.action_order

    content {
      order        = try(action_playbook.value.action_order, null)
      
        actionConfiguration {
            logic_app_id = try(action_playbook.value.actionConfiguration.logicAppResourceId, null)
            tenant_id    = try(action_playbook.value.actionConfiguration.tenantId, null)
        }

    }
  }

  dynamic "condition" {
    for_each = var.condition_type == null ? [] : var.condition_type

    content {

      conditionType = try(action_playbook.value.condition_type, null)

      conditionProperties {
          operator = try(condition.value.conditionProperties[0].operator, null)
          property = try(condition.value.conditionProperties[0].propertyName, null)
          values   = try(condition.value.conditionProperties[0].propertyValues, null)
          }
    }
  }
}