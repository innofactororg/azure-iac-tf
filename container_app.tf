module "container_apps" {
  source     = "./modules/compute/container_app"
  for_each   = local.compute.container_apps
  depends_on = [module.dynamic_keyvault_secrets]


  location                 = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name      = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  resource_group           = can(each.value.resource_group.id) || can(each.value.resource_group_id) ? try(each.value.resource_group.id, each.value.resource_group_id) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags                = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  client_config            = local.client_config
  combined_diagnostics     = local.combined_diagnostics
  diagnostic_profiles      = try(each.value.diagnostic_profiles, {})
  global_settings          = local.global_settings
  settings                 = each.value
  dynamic_keyvault_secrets = try(local.security.dynamic_keyvault_secrets, {})

  combined_resources = {
    keyvaults          = local.combined_objects_keyvaults
    managed_identities = local.combined_objects_managed_identities
    network_profiles   = local.combined_objects_network_profiles
  }
}


# module "container_app" {
#   source                   = "./modules/container_apps"
#   managed_environment_name = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}${var.managed_environment_name}"
#   location                 = var.location
#   resource_group_id        = azurerm_resource_group.rg.id
#   tags                     = var.tags
#   instrumentation_key      = module.application_insights.instrumentation_key
#   workspace_id             = module.log_analytics_workspace.workspace_id
#   primary_shared_key       = module.log_analytics_workspace.primary_shared_key
#   dapr_components = [{
#     name          = var.dapr_component_name
#     componentType = var.dapr_component_type
#     version       = var.dapr_component_version
#     ignoreErrors  = var.dapr_ignore_errors
#     initTimeout   = var.dapr_component_init_timeout
#     secrets = [
#       {
#         name  = "storageaccountkey"
#         value = module.storage_account.primary_access_key
#       }
#     ]
#     metadata : [
#       {
#         name  = "accountName"
#         value = module.storage_account.name
#       },
#       {
#         name  = "containerName"
#         value = var.container_name
#       },
#       {
#         name      = "accountKey"
#         secretRef = "storageaccountkey"
#       }
#     ]
#     scopes = var.dapr_component_scopes
#   }]
#   container_apps = var.container_apps
# }


output "container_apps" {
  value = module.container_apps
}

