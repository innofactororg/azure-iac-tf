

data "azurecaf_name" "managed_environment_name" {
  name          = var.settings.name
  resource_type = "azurerm_firewall_ip_configuration" // "azurerm_managed_app_environment"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


# resource "azapi_resource" "managed_environment" {
#   name = data.azurecaf_name.managed_environment_name.result
#   location  = var.location
#   parent_id = var.resource_group
#   type      = "Microsoft.App/managedEnvironments@2022-03-01"
#   tags      = merge(local.tags, try(var.settings.tags, null))
  
#   body = jsonencode({
#     properties = {
#       # daprAIInstrumentationKey = var.instrumentation_key
#       # appLogsConfiguration = {
#       #   destination = "log-analytics"
#       #   logAnalyticsConfiguration = {
#       #     customerId = var.workspace_id
#       #     sharedKey  = var.primary_shared_key
#       #   }
#       # }
#       vnetConfiguration = {
#         // CIDR notation IP range assigned to the Docker bridge, network. 
#         // Must not overlap with any other provided IP ranges.
#         dockerBridgeCidr = "string"
#         // Subnet for infrastructure components. 
#         // This subnet must be in the same VNET as the subnet defined in runtimeSubnetId.
#         // Must not overlap with any other provided IP ranges.
#         infrastructureSubnetId = "string"
#         // Indicating only has an internal load balancer. 
#         // These environments do not have a public static IP resource. 
#         // They must provide runtimeSubnetId and infrastructureSubnetId if enabling this property
#         internal = bool
#         // IP range in CIDR notation that can be reserved for environment infrastructure
#         // Must not overlap with any other provided IP ranges.
#         platformReservedCidr = "string"
#         // An IP address from the IP range defined by platformReservedCidr that will be reserved for the internal DNS server.
#         platformReservedDnsIP = "string"
#         runtimeSubnetId = "string"
        


# platformReservedCidr 	 	string
# platformReservedDnsIP 	 	string
# runtimeSubnetId 	Resource ID of a subnet that Container App containers are injected into. This subnet must be in the same VNET as the subnet defined in infrastructureSubnetId. Must not overlap with any other provided IP ranges.
#       }
#     }
#   })

#   timeouts {
#     create = "30m"
#   }

#   # lifecycle {
#   #   ignore_changes = [
#   #       tags
#   #   ]
#   # }
# }


# # resource "azapi_resource" "daprComponents" {
# #   for_each  = {for component in var.dapr_components: component.name => component}

# #   name      = each.key
# #   parent_id = azapi_resource.managed_environment.id
# #   type      = "Microsoft.App/managedEnvironments/daprComponents@2022-03-01"

# #   body = jsonencode({
# #     properties = {
# #       componentType   = each.value.componentType
# #       version         = each.value.version
# #       ignoreErrors    = each.value.ignoreErrors
# #       initTimeout     = each.value.initTimeout
# #       secrets         = each.value.secrets
# #       metadata        = each.value.metadata
# #       scopes          = each.value.scopes
# #     }
# #   })
# # }
# # resource "azapi_resource" "container_app" {
# #   for_each  = local.combined_containers

# #   name      = container.value.name
# #   location  = var.location
# #   parent_id = var.resource_group_id
# #   type      = "Microsoft.App/containerApps@2022-03-01"
# #   tags                = merge(local.tags, try(var.settings.tags, null))

# #   body = jsonencode({
# #     properties: {
# #       managedEnvironmentId  = azapi_resource.managed_environment.id
# #       configuration         = {
# #         # ingress             = try(each.value.configuration.ingress, null)
# #         # dapr                = try(each.value.configuration.dapr, null)
# #       }
# #       template              = {

# #       name   = container.value.name
# #       image  = container.value.image

# #     }
# #   })

# #   lifecycle {
# #     ignore_changes = [
# #         tags
# #     ]
# #   }
# # }



