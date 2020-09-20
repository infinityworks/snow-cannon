resource "snowflake_schema" "schema_marketing" {
  name     = "Marketing"
  database = data.terraform_remote_state.databases.outputs.analytics_db_name
  comment  = "Snow-cannon testing"
}
