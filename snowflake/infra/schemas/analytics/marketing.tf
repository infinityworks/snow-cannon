resource "snowflake_schema" "marketing" {
  name     = "Marketing"
  database = data.terraform_remote_state.databases.outputs.analytics_db_name
  comment  = "iw-snowflake-demo testing"
}
