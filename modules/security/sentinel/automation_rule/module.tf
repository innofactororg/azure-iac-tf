resource "azurerm_sentinel_automation_rule" "automation_rule" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  order                      = var.order
  enabled                    = var.enabled
  expiration                 = var.expiration

  dynamic "action_incident" {
    for_each = var.modify_properties== null ? [] : var.modify_properties
    content {
      order                  = try(action_incident.value.order, 1)
      status                 = try(action_incident.value.action_incident.status, "New")
      classification         = try(action_incident.value.classification, null)
      classification_comment = try(action_incident.value.classificationComment, null)
      labels                 = try(action_incident.value.labels, null)
      owner_id               = try(action_incident.value.owner, null)
      severity               = try(action_incident.value.severity, null)
    }
  }

  dynamic "action_playbook" {
    for_each = var.run_playbook == null ? [] : var.run_playbook
    content {
      logic_app_id   = action_playbook.value.logicAppResourceId
      order  = action_playbook.value.order
      tenant_id = action_playbook.value.tenantId
    }
  }
  }
  
  dynamic "condition" {
    for_each = var.condition_type == null ? [] : var.condition_type
    content {
      operator = try(condition.value.conditionProperties.operator, null)
      property = try(condition.value.conditionProperties.propertyName, null)
      values   = try(condition.value.conditionProperties.propertyValues, null)
    }
  }
  

}