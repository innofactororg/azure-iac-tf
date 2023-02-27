variable "name" {
  default = null
}
variable "log_analytics_workspace_id" {
  default = null
}
variable "display_name" {
  default = null
}
variable "severity" {
  default = null
  description = "values: High, Medium, Low, Informational"
}
variable "query" {
  default = null
}
variable "alert_rule_template_guid" {
  default = null
}
variable "description" {
  default = null
}
variable "enabled" {
  default = null
}
variable "query_frequency" {
  default = null
}
variable "query_period" {
  default = null
}
variable "suppression_duration" {
  default = null
}
variable "suppression_enabled" {
  default = null
}
variable "tactics" {
  default = null
}
variable "trigger_operator" {
  default = null
}
variable "trigger_threshold" {
  default = null
}
variable "settings" {
  default = null
}

variable "definition_file" {
  default = null
  description = "YAML File from which to load the definition, based on the schema defined in the Sentinel API and published "
}

variable "display_name_format" {
  default = null
}

variable "entity_mappings" {
  default = null
}