resource "snowflake_schema" "schema_marketing" {
  name     = "Marketing"
  database = data.terraform_remote_state.snowpipe_database.outputs.analytics_db_name
  comment  = "ADEWERRY testing"
}
