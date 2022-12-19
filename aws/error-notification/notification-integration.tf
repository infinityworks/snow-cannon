resource "snowflake_notification_integration" "snowpipe_error_channel" {
  # aws_sns_external_id   = "INFINITYWORKSPARTNER_SFCRole=4_HGXctH4Fp82LjjnTDH5tdBJo8Os="
  # aws_sns_iam_user_arn  = "arn:aws:iam::282654190546:user/1nyk-s-iess3910"
  aws_sns_role_arn      = "arn:aws:iam::054663422011:role/snow-cannon-snowpipe-error-notification-channel-dev"
  aws_sns_topic_arn     = "arn:aws:sns:eu-west-2:054663422011:snowpipe-error-notification-channel"
  comment               = "snow-cannon notification integration."
  direction             = "OUTBOUND"
  enabled               = true
  name                  = "SNOWPIPE_ERROR_CHANNEL"
  notification_provider = "AWS_SNS"
  type                  = "QUEUE"
}
