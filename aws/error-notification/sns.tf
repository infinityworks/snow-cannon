resource "aws_sns_topic" "snowpipe_error_notifaction_channel" {
  name = "snowpipe-error-notification-channel"

  policy = <<POLICY
{
    "Version":"2008-10-17",
    "Statement":[{
        "Sid"       : "__default_statement_ID", 
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
        "Resource": "arn:aws:sns:${local.config.providers.aws_region}:${data.aws_caller_identity.current.account_id}:snowpipe-error-notification-channel",
        "Condition":{
            "StringEquals":{"AWS:SourceOwner":"054663422011"}
        }
    }]
}
POLICY


}

resource "aws_sns_topic_subscription" "object_creation_subscription" {
  topic_arn = aws_sns_topic.snowpipe_error_notifaction_channel.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.error_channel.arn
}

data "aws_caller_identity" "current" {}