resource "snowflake_database" "db_ANALYTICS" {
  name                        = "ANALYTICS"
  comment                     = "ADEWERRY testing"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_ANALYTICS" {
  database_name = snowflake_database.db_ANALYTICS.name
  privilege     = "USAGE"

  roles = [
    var.role_BI_ANALYST,
    var.role_DATA_ANALYST,
  ]

}

resource "snowflake_database_grant" "modify_grants_on_db_ANALYTICS" {
  database_name = snowflake_database.db_ANALYTICS.name
  privilege     = "MODIFY"

  roles = [
    var.role_BI_ANALYST,
    var.role_DATA_ANALYST,
  ]
}
