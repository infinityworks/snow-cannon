resource "snowflake_stage" "stage_data_lake" {
  name                = "S3_EXTERNAL_DATA_LAKE_STAGE"
  database            = data.terraform_remote_state.snowpipe_database.outputs.analytics_db_name
  schema              = "PUBLIC"
  url                 = "S3://${data.terraform_remote_state.data_lake.outputs.data_lake_name}"
  storage_integration = data.terraform_remote_state.snowflake_integration.outputs.storage_integration_name
  comment             = "ADEWERRY testing"
}
