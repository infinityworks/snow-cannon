resource "snowflake_pipe" "pipe_data_lake" {
  name           = "DATA_LAKE_PIPE"
  auto_ingest    = "true"
  database       = var.database_analytics
  schema         = "PUBLIC"
  copy_statement = "COPY INTO ${var.snowpipe_table} from @${var.s3_external_stage} file_format = (type = 'CSV')"
  comment        = "ADEWERRY testing"
}
