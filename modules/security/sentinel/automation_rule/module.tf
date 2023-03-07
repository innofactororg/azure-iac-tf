resource "azurerm_sentinel_automation_rule" "automation_rule" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  order                      = var.order
  enabled                    = var.enabled
  expiration                 = var.expiration

  dynamic "action_incident" {
    # for_each = var.action_type == "RunPlaybook" ? [] : var.action_type
    for_each = lookup(var.action_order, "RunPlaybook", {}) != {} ? [1] : [] 

    content {
      order                  = try(action_incident.value.order, 1)
      status                 = try(action_incident.value.actionConfiguration.status, "New")
      classification         = try(action_incident.value.actionConfiguration.classification, null)
      classification_comment = try(action_incident.value.actionConfiguration.classificationComment, null)
      labels                 = try(action_incident.value.actionConfiguration.labels, null)
      owner_id               = try(action_incident.value.actionConfiguration.owner, null)
      severity               = try(action_incident.value.actionConfiguration.severity, null)
    }
  }

  dynamic "action_playbook" {
    # for_each = var.action_type == "ModifyProperties" ? [] : var.action_type
    for_each = lookup(var.action_order, "ModifyProperties", {}) != {} ? [1] : [] 

    content {
      order        = try(action_playbook.value.order, null)
      
        # actionConfiguration {
            logic_app_id = try(action_playbook.value.actionConfiguration.logicAppResourceId, null)
            tenant_id    = try(action_playbook.value.actionConfiguration.tenantId, null)
        # }

    }
  }

  dynamic "condition" {
    for_each = var.condition_type == null ? [] : var.condition_type

    content {

      # conditionType = try(action_playbook.value.condition_type, null)

      # conditionProperties {
          operator = try(condition.value.conditionProperties.operator, null)
          property = try(condition.value.conditionProperties.propertyName, null)
          values   = try(condition.value.conditionProperties.propertyValues, null)
          # }
    }
  }

}