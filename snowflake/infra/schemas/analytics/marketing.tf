resource "snowflake_schema" "schema_marketing" {
  name     = "Marketing"
  database = var.database_analytics
  comment  = "ADEWERRY testing"
}
