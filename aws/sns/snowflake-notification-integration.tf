resource "snowflake_notification_integration" "snowpipe_error_channel" {
  name    = "snowpipe_error_channel"
  comment = "${local.project_name} notification integration."

  enabled   = true
  type      = "QUEUE"
  direction = "OUTBOUND"


  # AWS_SQS
  #notification_provider = "AWS_SQS"
  #aws_sqs_arn           = "..."
  #aws_sqs_role_arn      = "..."


  notification_provider = "AWS_SNS"
  aws_sns_topic_arn     = aws_sns_topic.snowpipe_error_notifaction_channel.arn
  aws_sns_role_arn      = aws_iam_role.snow_pipe_error_notification_channel.arn
}

#  resource "snowflake_pipe" "create_pipe" {
#   name           = "T_DATA_PIPE"
#   auto_ingest    = "true"
#   database       = "ANALYTICS"
#   schema         = "PUBLIC"
#   copy_statement = "COPY INTO ANALYTICS.PUBLIC.TRANSACTIONS from ( SELECT $1, TO_TIMESTAMP_NTZ(current_timestamp) FROM @ANALYTICS.PUBLIC.TRANSACTIONS_EXTERNAL_STAGE) file_format = (type = 'JSON'      )"
# #   aws_sns_topic_arn   = aws_sns_topic.snowpipe_error_notifaction_channel.arn
#   error_integration = snowflake_notification_integration.snowpipe_error_channel.name
#   comment        = "Pipe to ingest data "
# }
