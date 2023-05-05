module "sentinel_automation_rules" {
  source   = "./modules/security/sentinel/automation_rule"
  for_each = try(local.security.sentinel_automation_rules, {})

  name                                = try(each.value.name, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["id"], yamldecode(file("${path.cwd}/${each.value.definition_file}"))["name"],each.value.name )
  display_name                        = try(each.value.display_name, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["displayName"],each.value.name)
  settings                            = each.value
  log_analytics_workspace_id          = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  order                               = try(each.value.order, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["order"])
  enabled                             = try(each.value.enabled, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["triggeringLogic"].isEnabled, true)
  expiration                          = try(each.value.expiration, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["triggeringLogic"].expiration, null)
  combined_objects_logic_app_workflow = local.combined_objects_logic_app_workflow
  client_config                       = local.client_config
  modify_properties                    = try(each.value.action_order, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["modifyProperties"], null)
  run_playbook                    = try(each.value.action_order, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["runPlaybook"], null)
  condition_type                      = try(each.value.condition_type, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["triggeringLogic"].conditions, null)
}

module "sentinel_watchlists" {
  source   = "./modules/security/sentinel/watchlist"
  for_each = try(local.security.sentinel_watchlists, {})

  name                       = each.value.name
  display_name               = each.value.display_name
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  default_duration           = try(each.value.default_duration, null)
  description                = try(each.value.description, null)
  labels                     = try(each.value.labels, null)
  item_search_key            = try(each.value.item_search_key, null)
}

module "sentinel_watchlist_items" {
  source   = "./modules/security/sentinel/watchlist_item"
  for_each = try(local.security.sentinel_watchlist_items, {})

  name         = try(each.value.name, null)
  watchlist_id = local.combined_objects_sentinel_watchlists[try(each.value.sentinel_watchlist.lz_key, local.client_config.landingzone_key)][each.value.sentinel_watchlist.key].id
  properties   = each.value.properties
}

module "sentinel_ar_fusions" {
  source   = "./modules/security/sentinel/ar_fusion"
  for_each = try(local.security.sentinel_ar_fusions, {})

  name                       = each.value.name
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  alert_rule_template_guid   = each.value.alert_rule_template_guid
  enabled                    = try(each.value.enabled, true)
}

module "sentinel_ar_ml_behavior_analytics" {
  source   = "./modules/security/sentinel/ar_ml_behavior_analytics"
  for_each = try(local.security.sentinel_ar_ml_behavior_analytics, {})

  name                       = each.value.name
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  alert_rule_template_guid   = each.value.alert_rule_template_guid
  enabled                    = try(each.value.enabled, true)
}

module "sentinel_ar_ms_security_incidents" {
  source   = "./modules/security/sentinel/ar_ms_security_incident"
  for_each = try(local.security.sentinel_ar_ms_security_incidents, {})

  name                        = each.value.name
  log_analytics_workspace_id  = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  display_name                = each.value.display_name
  product_filter              = each.value.product_filter
  severity_filter             = each.value.severity_filter
  alert_rule_template_guid    = try(each.value.alert_rule_template_guid, null)
  description                 = try(each.value.description, null)
  enabled                     = try(each.value.enabled, true)
  display_name_filter         = try(each.value.display_name_filter, null)
  display_name_exclude_filter = try(each.value.display_name_exclude_filter, null)
}

module "sentinel_ar_scheduled" {
  source   = "./modules/security/sentinel/ar_scheduled"
  for_each = try(local.security.sentinel_ar_scheduled, {})

  name                       = try(each.value.name, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["id"], yamldecode(file("${path.cwd}/${each.value.definition_file}"))["name"],each.value.name )
  display_name = try(each.value.display_name, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["name"],each.value.name)
  settings                   = each.value
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  severity = try(each.value.severity, try(yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["severity"], null ), "Informational")
  query                      = try(each.value.query, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["query"])
  alert_rule_template_guid   = try(each.value.alert_rule_template_guid, null)
  description                = try(each.value.description, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["description"], null)
  enabled                    = try(each.value.enabled, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["enabled"], true)
  query_frequency            = try(each.value.query_frequency, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["queryFrequency"], "PT5H")
  query_period               = try(each.value.query_period, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["queryPeriod"], "PT5H")
  suppression_duration       = try(each.value.suppression_duration, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["suppressionDuration"], "PT5H")
  suppression_enabled        = try(each.value.suppression_enabled, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["suppressionEnabled"], false)
  tactics                    = try(each.value.tactics, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["tactics"], null)
  trigger_operator           = try(each.value.trigger_operator, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["triggerOperator"], null)
  trigger_threshold          = try(each.value.trigger_threshold, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["triggerThreshold"], null)
  display_name_format        = try(each.value.display_name_format, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["alertDetailsOverride"].alertDisplayNameFormat,null)
  entity_mappings                = try(each.value.entityMappings, yamldecode(file("${path.cwd}/${each.value.definition_file}"))["properties"]["entityMappings"], null)
}

module "sentinel_dc_aad" {
  source   = "./modules/security/sentinel/dc_aad"
  for_each = try(local.security.sentinel_dc_aad, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}

module "sentinel_dc_app_security" {
  source   = "./modules/security/sentinel/dc_app_security"
  for_each = try(local.security.sentinel_dc_app_security, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
  alerts_enabled             = try(each.value.alerts_enabled, null)
  discovery_logs_enabled     = try(each.value.discovery_logs_enabled, null)
}

module "sentinel_dc_aws" {
  source   = "./modules/security/sentinel/dc_aws"
  for_each = try(local.security.sentinel_dc_aws, {})

  aws_role_arn               = each.value.aws_role_arn
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}

module "sentinel_dc_azure_threat_protection" {
  source   = "./modules/security/sentinel/dc_azure_threat_protection"
  for_each = try(local.security.sentinel_dc_azure_threat_protection, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}

module "sentinel_dc_ms_threat_protection" {
  source   = "./modules/security/sentinel/dc_ms_threat_protection"
  for_each = try(local.security.sentinel_dc_ms_threat_protection, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}

module "sentinel_dc_office_365" {
  source   = "./modules/security/sentinel/dc_office_365"
  for_each = try(local.security.sentinel_dc_office_365, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
  exchange_enabled           = try(each.value.exchange_enabled, true)
  sharepoint_enabled         = try(each.value.sharepoint_enabled, true)
  teams_enabled              = try(each.value.teams_enabled, true)
}

module "sentinel_dc_security_center" {
  source   = "./modules/security/sentinel/dc_security_center"
  for_each = try(local.security.sentinel_dc_security_center, {})

  subscription_id            = try(each.value.subscription_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}

module "sentinel_dc_threat_intelligence" {
  source   = "./modules/security/sentinel/dc_threat_intelligence"
  for_each = try(local.security.sentinel_dc_threat_intelligence, {})

  tenant_id                  = try(each.value.tenant_id, null)
  log_analytics_workspace_id = can(each.value.diagnostic_log_analytics_workspace) || can(each.value.log_analytics_workspace.id) ? try(local.combined_diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.combined_objects_log_analytics[try(each.value.log_analytics_workspace.lz_key, local.client_config.landingzone_key)][each.value.log_analytics_workspace.key].id
  name                       = each.value.name
}