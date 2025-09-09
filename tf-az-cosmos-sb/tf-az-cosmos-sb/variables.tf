variable "location" {
  type        = string
  default     = "centralindia" # Change if you want another region
  description = "Azure region for all resources"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-sandhata-cosmos-sb"
  description = "Resource Group name"
}

variable "prefix" {
  type        = string
  default     = "sandhata-demo"
  description = "Short lowercase prefix for names"
}

variable "cosmos_account_name" {
  type        = string
  default     = "" # auto-generated if blank
}

variable "cosmos_db_name" {
  type        = string
  default     = "appdb"
}

variable "cosmos_container_name" {
  type        = string
  default     = "items"
}

variable "cosmos_partition_key_path" {
  type        = string
  default     = "/id"
}

variable "enable_serverless" {
  type        = bool
  default     = true
  description = "Enable Cosmos DB serverless"
}

variable "enable_free_tier" {
  type        = bool
  default     = false # free tier only once per subscription
}

variable "sb_namespace_name" {
  type        = string
  default     = "" # auto-generated if blank
}

variable "sb_sku" {
  type        = string
  default     = "Basic" # Basic is cheapest, good for test
}

variable "sb_queue_name" {
  type        = string
  default     = "appqueue"
}

variable "tags" {
  type        = map(string)
  default     = {
    project = "cosmos-sb-basic"
    env     = "dev"
  }
}

