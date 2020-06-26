resource "snowflake_stage" "stage_data_lake" {
  name     = "data_lake_stage"
  database = module.databases.analytics_database
  schema   = module.analytics_schemas.marketing_schema
  url      = var.s3_data_lake
  comment  = "ADEWERRY testing"
}
