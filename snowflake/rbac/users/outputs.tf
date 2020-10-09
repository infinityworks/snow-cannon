output "debug" {
  value = {
    config = module.config.entries
  }
}

output "user_ANALYST_name" {
  value = snowflake_user.user_ANALYST.name
}
