output "debug" {
  value = {
    config = module.config.entries
  }
}

output "analytics_db_name" {
  value = snowflake_database.db_ANALYTICS.name
}
