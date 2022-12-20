resource "aws_iam_role" "snow_pipe_error_notification_channel" {
  name               = "${local.project_name}-snowpipe-error-notification-channel-${local.env_formatted_lower}"
  assume_role_policy = data.aws_iam_policy_document.snowflake_publish_pipe_error.json
  tags = {
    "Description" = "Role used by Snowflake to publish pipe error messages to our SNS service"
  }
}

resource "aws_iam_role_policy" "snow_pipe_error_notification_channel" {
  name   = aws_iam_role.snow_pipe_error_notification_channel.name
  role   = aws_iam_role.snow_pipe_error_notification_channel.name
  policy = data.aws_iam_policy_document.sns_publish_snowpipe_error_notifaction_channel.json
}

data "aws_iam_policy_document" "sns_publish_snowpipe_error_notifaction_channel" {
  statement {
    sid       = "publishErrorToSNS"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.snowpipe_error_notifaction_channel.arn]
  }
}

data "aws_iam_policy_document" "snowflake_publish_pipe_error" {
  statement {
    sid     = "errorChannelAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [snowflake_notification_integration.snowpipe_error_channel.aws_sns_iam_user_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        snowflake_notification_integration.snowpipe_error_channel.aws_sns_external_id
      ]
    }
  }
}
