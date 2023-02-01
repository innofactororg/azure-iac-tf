
variable "location" {}
variable "resource_group_name" {}
variable "resource_group" {
  description = "(Required) The resource id of the resource group in which to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "global_settings" {}
variable "settings" {}
variable "base_tags" {}
variable "client_config" {}
variable "dynamic_keyvault_secrets" {
  description = "Provide credenrials for private image registries"
  default     = {}
}

// these are currently ignored
variable "combined_diagnostics" {}
variable "diagnostic_profiles" {}
variable "combined_resources" {
  description = "Provide a map of combined resources for environment_variables_from_resources"
  default     = {}
}

# variable "dapr_components" {
#   description = "Specifies the dapr components in the managed environment."
#   type = list(object({
#     name           = string
#     componentType  = string
#     version        = string
#     ignoreErrors   = optional(bool)
#     initTimeout    = string
#     secrets        = optional(list(object({
#       name         = string
#       value        = any
#     })))
#     metadata       = optional(list(object({
#       name         = string
#       value        = optional(any)
#       secretRef    = optional(any)
#     })))
#     scopes         = optional(list(string))
#   }))
# }

# variable "container_apps" {
#   description = "Specifies the container apps in the managed environment."
#   type = list(object({
#     name                = string
#     configuration       = object({
#       ingress           = optional(object({
#         external        = optional(bool)
#         targetPort      = optional(number)
#       }))
#       dapr              = optional(object({
#         enabled         = optional(bool)
#         appId           = optional(string)
#         appProtocol     = optional(string)
#         appPort         = optional(number)
#       }))
#     })
#     template           = object({
#       containers       = list(object({
#         image          = string
#         name           = string
#         env            = optional(list(object({
#           name         = string
#           value        = string
#         })))
#         resources      = optional(object({
#           cpu          = optional(number)
#           memory       = optional(string)
#         }))
#       }))
#       scale            = optional(object({
#         minReplicas    = optional(number)
#         maxReplicas    = optional(number)
#       }))
#     })
#   }))
# }