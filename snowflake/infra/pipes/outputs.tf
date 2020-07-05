output "pipe_sqs_arn" {
  value = snowflake_pipe.pipe_data_lake.notification_channel
}
