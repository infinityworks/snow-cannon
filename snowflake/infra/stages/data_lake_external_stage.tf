resource "snowflake_stage" "stage_data_lake" {
  name                = "S3_EXTERNAL_DATA_LAKE_STAGE"
  database            = var.database_analytics
  schema              = "PUBLIC"
  url                 = var.s3_data_lake
  storage_integration = data.terraform_remote_state.snowflake_integration.outputs.storage_integration_name
  comment             = "ADEWERRY testing"
}
