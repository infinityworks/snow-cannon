output "debug" {
  value = {
    config = module.config.entries
  }
}

output "user_analyst_name" {
  value = snowflake_user.analyst.name
}
