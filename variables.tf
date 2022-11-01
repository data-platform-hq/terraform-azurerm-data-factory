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

variable "sas_expiration_date" {
  type        = string
  description = "This token is used by Storage Account linked service for Snowflake and it is expiring on certain date"
}

# Optional
variable "prefix" {
  type        = string
  description = "Resource name prefix"
  default     = ""
}

variable "suffix" {
  type        = string
  description = "Resource name suffix"
  default     = ""
}

variable "account_kind" {
  type        = string
  description = "Kind of account. [BlobStorage|BlockBlobStorage|FileStorage|Storage|StorageV2]"
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Tier to use for this storage account: [Standard|Premium]"
  default     = "Standard"
}

variable "replication_type" {
  type        = string
  description = "The type of replication to use: [LRS|GRS|RAGRS|ZRS|GZRS|RAGZRS]"
  default     = "GRS"
}

variable "access_tier" {
  type        = string
  description = "The access tier for BlobStorage, FileStorage and StorageV2"
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled: [true|false]"
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account: [TLS1_0|TLS1_1|TLS1_2]"
  default     = "TLS1_2"
}

variable "is_hns_enabled" {
  type        = bool
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2: [true|false]"
  default     = true
}

variable "network_rules" {
  type        = list(any)
  description = "List of network rules maps"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "default_action" {
  type        = string
  description = "Specifies the default action of allow or deny when no other rules match"
  default     = "Deny"
}

variable "bypass" {
  type        = set(string)
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  default     = ["AzureServices"]
}

variable "ip_rules" {
  type        = map(string)
  description = "Map of IP addresses permitted to access storage account"
  default     = null
}

variable "virtual_networks" {
  type        = list(string)
  description = "A list of resource ids for subnets"
  default     = null
}

variable "permissions" {
  type        = list(map(string))
  description = "Storage permision map"
  default = [
    {
      object_id = null
      role      = null
    }
  ]
}

variable "log_analytics_workspace" {
  type        = map(string)
  default     = {}
  description = "Log Analytics Workspace Name to ID map"
}

variable "log_category_list" {
  type        = list(string)
  description = "Storegr log category list"
  default = [
    "StorageRead",
    "StorageWrite",
    "StorageDelete"
  ]
}

variable "log_retention_days" {
  default     = 0
  description = "Retention policy days"
  type        = number
}

variable "metric_retention_days" {
  default     = 0
  description = "Retention policy days"
  type        = number
}

variable "destination_type" {
  type        = string
  description = "Log analytics destination type"
  default     = "Dedicated"
}
