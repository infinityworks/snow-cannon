resource "snowflake_database" "db_ANALYTICS" {
  name                        = "IW_DEMO"
  comment                     = "Data presented in the analytics layer"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_ANALYTICS" {
  database_name = snowflake_database.db_ANALYTICS.name
  privilege     = "USAGE"

  roles = [
    data.terraform_remote_state.role_info.outputs.BI_ANALYST_name,
    data.terraform_remote_state.role_info.outputs.DATA_ANALYST_name,
  ]
}

resource "snowflake_database_grant" "modify_grants_on_db_ANALYTICS" {
  database_name = snowflake_database.db_ANALYTICS.name
  privilege     = "MODIFY"

  roles = [
    data.terraform_remote_state.role_info.outputs.BI_ANALYST_name,
    data.terraform_remote_state.role_info.outputs.DATA_ANALYST_name,
  ]
}
