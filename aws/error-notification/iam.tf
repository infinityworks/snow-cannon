resource "aws_iam_role" "snow_pipe_error_notification_channel" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Condition = {
            StringEquals = {
              "sts:ExternalId" = "INFINITYWORKSPARTNER_SFCRole=4_HGXctH4Fp82LjjnTDH5tdBJo8Os="
            }
          }
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::282654190546:user/1nyk-s-iess3910"
          }
          Sid = "errorChannelAssumeRole"
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns   = []
  max_session_duration  = 3600
  name                  = "snow-cannon-snowpipe-error-notification-channel-dev"
  path                  = "/"
  tags = {
    "Description" = "Role for Programmatic user to adopt for CI deployments"
  }
  tags_all = {
    "Description" = "Role for Programmatic user to adopt for CI deployments"
    "Environment" = "dev"
    "Project"     = "snow-cannon"
  }

  inline_policy {
    name = "snow-cannon-snowpipe-error-notification-channel-dev"
    policy = jsonencode(
      {
        Statement = [
          {
            Action   = "sns:Publish"
            Effect   = "Allow"
            Resource = "arn:aws:sns:eu-west-2:054663422011:snowpipe-error-notification-channel"
            Sid      = "publishErrorToSNS"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}

resource "aws_iam_role_policy" "snow_pipe_error_notification_channel" {
  name = "snow-cannon-snowpipe-error-notification-channel-dev"
  policy = jsonencode(
    {
      Statement = [
        {
          Action   = "sns:Publish"
          Effect   = "Allow"
          Resource = "arn:aws:sns:eu-west-2:054663422011:snowpipe-error-notification-channel"
          Sid      = "publishErrorToSNS"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = "snow-cannon-snowpipe-error-notification-channel-dev"
}
