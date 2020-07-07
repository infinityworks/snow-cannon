resource "snowflake_pipe" "pipe_data_lake" {
  provider       = snowflake.snowflake
  name           = "DATA_LAKE_PIPE"
  auto_ingest    = "true"
  database       = data.terraform_remote_state.snowpipe_database.outputs.analytics_db_name
  schema         = "PUBLIC"
  copy_statement = "COPY INTO ${var.snowpipe_table} from @${var.s3_external_stage} file_format = (type = 'CSV')"
  comment        = "ADEWERRY testing"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  provider = aws.aws
  bucket   = data.terraform_remote_state.data_lake.outputs.data_lake_name

  queue {
    queue_arn = snowflake_pipe.pipe_data_lake.notification_channel
    events    = ["s3:ObjectCreated:*"]
  }
}
