resource "aws_iam_role" "storage_integration_iam_role" {
  name = "${var.project}-storage-integration-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.terraform_remote_state.snowflake_integration.outputs.storage_integration_snowflake_arn}"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${data.terraform_remote_state.snowflake_integration.outputs.storage_integration_external_id}"
        }
      }
    }
  ]
}
EOF

  tags = {
    Name  = "${var.project}-storage-integration-role"
    Owner = "adam.dewberry"
    Live  = var.is_live
  }
}

data "aws_iam_policy_document" "storage_integration_policy_document" {
  statement {
    sid = "snowflakeGetFromS3"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "${data.terraform_remote_state.data_lake.outputs.data_lake_arn}/*"
    ]
  }

  statement {
    sid = "snowflakeListS3"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      data.terraform_remote_state.data_lake.outputs.data_lake_arn
    ]
  }
}

resource "aws_iam_policy" "storage_integration_policy" {
  name   = "${var.project}-storage-integration-policy"
  policy = data.aws_iam_policy_document.storage_integration_policy_document.json
}

resource "aws_iam_role_policy_attachment" "storage_integration_policy_attachment" {
  role       = aws_iam_role.storage_integration_iam_role.name
  policy_arn = aws_iam_policy.storage_integration_policy.arn
}
