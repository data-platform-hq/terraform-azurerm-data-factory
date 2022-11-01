# Required
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

# Optional
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

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name to use"
  default     = ""
}

variable "key_vault_resource_group" {
  type        = string
  description = "Azure Key Vault resource group (if differs from from target one)"
  default     = ""
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

# Log Analytics
variable "log_analytics_workspace" {
  type        = map(string)
  description = "Log Analytics Workspace Name to ID map"
  default     = {}
}

variable "log_category_list" {
  default = [
    "ActivityRuns",
    "PipelineRuns",
    "TriggerRuns"
  ]
  type        = list(string)
  description = "Categoty list log"
}

variable "log_retention_days" {
  default     = 0
  type        = number
  description = "Retention policy days"
}

variable "metric_retention_days" {
  default     = 0
  type        = number
  description = "Retention policy days"
}

variable "destination_type" {
  type        = string
  default     = "Dedicated"
  description = "Log analytics destination type"
}
