resource "snowflake_database" "db_UTIL_CLONE" {
  name                        = "UTIL_CLONE"
  from_database               = "UTIL_DB"
  comment                     = "ADEWERRY testing"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_UTIL_CLONE" {
  database_name = snowflake_database.db_UTIL_CLONE.name
  privilege     = "USAGE"

  roles = [
    var.role_BI_ANALYST,
    var.role_DATA_ANALYST,
  ]

}

resource "snowflake_database_grant" "modify_grants_on_db_UTIL_CLONE" {
  database_name = snowflake_database.db_UTIL_CLONE.name
  privilege     = "MODIFY"

  roles = [
    var.role_BI_ANALYST,
    var.role_DATA_ANALYST,
  ]

}
