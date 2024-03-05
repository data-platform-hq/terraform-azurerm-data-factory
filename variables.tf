variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "resource_group" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "custom_adf_name" {
  type        = string
  description = "Specifies the name of the Data Factory"
  default     = null
}

variable "custom_default_ir_name" {
  type        = string
  description = "Specifies the name of the Managed Integration Runtime"
  default     = null
}

variable "custom_diagnostics_name" {
  type        = string
  description = "Specifies the name of Diagnostic Settings that monitors ADF"
  default     = null
}

variable "custom_shir_name" {
  type        = string
  description = "Specifies the name of Self Hosted Integration runtime"
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "public_network_enabled" {
  type        = bool
  description = "Is the Data Factory visible to the public network?"
  default     = false
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "Is Managed Virtual Network enabled?"
  default     = true
}

variable "cleanup_enabled" {
  type        = bool
  description = "Cluster will not be recycled and it will be used in next data flow activity run until TTL (time to live) is reached if this is set as false"
  default     = true
}

variable "compute_type" {
  type        = string
  description = "Compute type of the cluster which will execute data flow job: [General|ComputeOptimized|MemoryOptimized]"
  default     = "General"
}

variable "core_count" {
  type        = number
  description = "Core count of the cluster which will execute data flow job: [8|16|32|48|144|272]"
  default     = 8
}

variable "vsts_configuration" {
  type        = map(string)
  description = "Code storage configuration map"
  default     = {}
}

variable "permissions" {
  type        = list(map(string))
  description = "Data Factory permision map"
  default = [
    {
      object_id = null
      role      = null
    }
  ]
}

variable "time_to_live_min" {
  type        = string
  description = "TTL for Integration runtime"
  default     = 15
}

variable "virtual_network_enabled" {
  type        = bool
  description = "Managed Virtual Network for Integration runtime"
  default     = true
}

variable "self_hosted_integration_runtime_enabled" {
  type        = bool
  description = "Self Hosted Integration runtime"
  default     = false
}

# Log Analytics
variable "log_analytics_workspace" {
  type        = map(string)
  description = "Log Analytics Workspace Name to ID map"
  default     = {}
}

variable "analytics_destination_type" {
  type        = string
  default     = "Dedicated"
  description = "Log analytics destination type"
}

variable "managed_private_endpoint" {
  type = set(object({
    name               = string
    target_resource_id = string
    subresource_name   = string
  }))
  description = "The ID  and sub resource name of the Private Link Enabled Remote Resource which this Data Factory Private Endpoint should be connected to"
  default     = []
}

variable "global_parameter" {
  type = list(object({
    name  = string
    type  = optional(string, "String")
    value = string
  }))
  default     = []
  description = "Configuration of data factory global parameters"
}
