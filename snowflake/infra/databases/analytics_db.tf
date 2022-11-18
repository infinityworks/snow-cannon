resource "snowflake_database" "analytics" {
  name                        = "ANALYTICS"
  comment                     = "Data presented in the analytics layer"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_analytics" {
  database_name = snowflake_database.analytics.name
  privilege     = "USAGE"

  roles = [
    data.terraform_remote_state.role_info.outputs.bi_analyst_name,
    data.terraform_remote_state.role_info.outputs.data_analyst_name,
  ]
}

resource "snowflake_database_grant" "modify_grants_on_db_analytics" {
  database_name = snowflake_database.analytics.name
  privilege     = "MODIFY"

  roles = [
    data.terraform_remote_state.role_info.outputs.bi_analyst_name,
    data.terraform_remote_state.role_info.outputs.data_analyst_name,
  ]
}
