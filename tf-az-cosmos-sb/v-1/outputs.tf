# Cosmos DB
output "cosmos_account_name" {
  value       = azurerm_cosmosdb_account.cosmos.name
  description = "Cosmos DB account name"
}

output "cosmos_account_endpoint" {
  value       = azurerm_cosmosdb_account.cosmos.endpoint
  description = "Cosmos DB endpoint"
}

output "cosmos_primary_key" {
  value       = data.azurerm_cosmosdb_account.cosmos_read.primary_key
  sensitive   = true
}

# Service Bus
output "servicebus_namespace" {
  value       = azurerm_servicebus_namespace.sb.name
  description = "Service Bus namespace"
}

output "servicebus_queue_name" {
  value       = azurerm_servicebus_queue.queue.name
  description = "Service Bus queue name"
}

output "servicebus_primary_connection_string" {
  value       = azurerm_servicebus_namespace.sb.default_primary_connection_string
  sensitive   = true
}

