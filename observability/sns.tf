resource "aws_sns_topic" "snowpipe_error_notifaction_channel" {
  name = "snowpipe-error-notification-channel"
}

resource "aws_sns_topic_subscription" "snowpipe_error_notifaction_channel" {
  topic_arn = aws_sns_topic.snowpipe_error_notifaction_channel.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.error_channel.arn
}
