resource "snowflake_notification_integration" "snowpipe_error_channel" {
  aws_sns_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.project_name}-snowpipe-error-notification-channel-dev"
  aws_sns_topic_arn     = aws_sns_topic.snowpipe_error_notifaction_channel.arn
  comment               = "snow-cannon notification integration."
  direction             = "OUTBOUND"
  enabled               = true
  name                  = "SNOWPIPE_ERROR_CHANNEL"
  notification_provider = "AWS_SNS"
  type                  = "QUEUE"
}

data "aws_caller_identity" "current" {}
