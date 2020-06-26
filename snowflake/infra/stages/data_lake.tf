resource "snowflake_stage" "stage_data_lake" {
  name     = "data_lake_stage"
  database = var.database_analytics
  schema   = var.schema_db_analytics_marketing
  url      = var.s3_data_lake
  comment  = "ADEWERRY testing"
}
