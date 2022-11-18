output "debug" {
  value = {
    config = module.config.entries
  }
}

output "BI_ANALYST_name" {
  value = snowflake_role.bi_analyst.name
}

output "DATA_ANALYST_name" {
  value = snowflake_role.data_analyst.name
}
