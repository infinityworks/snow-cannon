output "debug" {
  value = {
    config = module.config.entries
  }
}

output "bi_analyst_name" {
  value = snowflake_role.bi_analyst.name
}

output "data_analyst_name" {
  value = snowflake_role.data_analyst.name
}
