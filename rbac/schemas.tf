resource "snowflake_schema" "schema_Marketing" {
  name     = "Marketing"
  database = snowflake_database.db_ANALYTICS_TEST.name
  comment  = "ADEWERRY testing"
}
