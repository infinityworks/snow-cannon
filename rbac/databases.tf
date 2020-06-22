resource "snowflake_database" "db_ANALYTICS_TEST" {
  provider                    = snowflake.systems
  name                        = "ANALYTICS_TEST"
  comment                     = "ADEWERRY testing"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_ANALYTICS_TEST" {
  provider      = snowflake.systems
  database_name = snowflake_database.db_ANALYTICS_TEST.name
  privilege     = "USAGE"

  roles = [
    "${snowflake_role.role_BI_ANALYST.name}",
    "${snowflake_role.role_DATA_ANALYST.name}",
  ]

}

resource "snowflake_database_grant" "modify_grants_on_db_ANALYTICS_TEST" {
  provider      = snowflake.systems
  database_name = snowflake_database.db_ANALYTICS_TEST.name
  privilege     = "MODIFY"

  roles = [
    "${snowflake_role.role_BI_ANALYST.name}",
    "${snowflake_role.role_DATA_ANALYST.name}",
  ]

}
