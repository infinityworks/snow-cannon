resource "aws_sqs_queue" "error_channel" {
  name                      = "${local.project_name}-pipe-error-notifications"
  delay_seconds             = 0
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.error_channel_dead_letter_queue.arn
    maxReceiveCount     = 5
  })

  tags = {
    Description = "Snow Cannon"
  }
}

resource "aws_sqs_queue" "error_channel_dead_letter_queue" {
  name                      = "${local.project_name}-pipe-error-notifications-dead-letter-queue"
  delay_seconds             = 0
  message_retention_seconds = 1209600

  tags = {
    Name = "${local.project_name}-object-created-dead-letter-queue"
  }
}

resource "aws_sqs_queue_policy" "object_created_queue_policy" {
  queue_url = aws_sqs_queue.error_channel.id
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "dataPlatformDmsRawObjectCreatedQueuePolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {"Service":"sns.amazonaws.com"},
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.error_channel.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.snowpipe_error_notifaction_channel.arn}"
        }
      }
    }
  ]
}
 POLICY
}
