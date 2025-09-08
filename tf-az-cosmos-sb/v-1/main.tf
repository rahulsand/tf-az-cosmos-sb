resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

locals {
  cosmos_account_name = length(var.cosmos_account_name) > 0 ? var.cosmos_account_name : "${var.prefix}cosmos${random_string.suffix.result}"
  sb_namespace_name   = length(var.sb_namespace_name) > 0   ? var.sb_namespace_name   : "${var.prefix}-sb-${random_string.suffix.result}"
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = local.cosmos_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB" # SQL API
  tags       = var.tags

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level = "Session"
  }

  enable_free_tier = var.enable_free_tier

  dynamic "capabilities" {
    for_each = var.enable_serverless ? [1] : []
    content {
      name = "EnableServerless"
    }
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.cosmos_db_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.cosmos_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name

  partition_key_path    = var.cosmos_partition_key_path
  partition_key_version = 1
}

data "azurerm_cosmosdb_account" "cosmos_read" {
  name                = azurerm_cosmosdb_account.cosmos.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Service Bus Namespace + Queue
resource "azurerm_servicebus_namespace" "sb" {
  name                = local.sb_namespace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.sb_sku
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  name                = var.sb_queue_name
  resource_group_name = azurerm_resource_group.rg.name
  namespace_id        = azurerm_servicebus_namespace.sb.id
}

