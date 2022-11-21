resource "aws_iam_role" "snow_pipe_error_notification_channel" {
  name                 = "${local.project_name}-snowpipe-error-notification-channel-${local.config.env_formatted.lower}"
  permissions_boundary = var.permissions_boundary
  path                 = var.path
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::282654190546:user/1nyk-s-iess3910"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "INFINITYWORKSPARTNER_SFCRole=4_hf+IQekCiQYAJOXOaP7Qbeve4P4="
        }
      }
    }
  ]
}
EOF
  tags = {
    Description = "Role for Programmatic user to adopt for CI deployments"
  }
}

resource "aws_iam_role_policy" "snow_pipe_error_notification_channel" {
  name   = "${local.project_name}-snowpipe-error-notification-channel-${local.config.env_formatted.lower}"
  policy = data.aws_iam_policy_document.snow_pipe_error_notification_channel.json
  role   = aws_iam_role.snow_pipe_error_notification_channel.id
}

data "aws_iam_policy_document" "snow_pipe_error_notification_channel" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = [aws_sns_topic.snowpipe_error_notifaction_channel.arn]

    actions = [
      "sns:Publish"
    ]
  }
}
