resource "aws_iam_role" "storage_integration_role" {
  name                 = "${local.formatted_iam_name}-snowflake-storage-integration-role"
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
        "AWS": "${var.snowflake_storage_integration_user_arn}"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.snowflake_storage_integration_external_id}"
        }
      }
    }
  ]
}
EOF


  tags = {
    Contact     = "Adam.Dewberry@infinityworks.com"
    Description = "IAM role used in Snowflake account integrations"
    Purpose     = "Infra used in demoing Snowflake quick deploments"
    Source      = var.s3_path
  }
}

data "aws_iam_policy_document" "storage_integration_policy_document" {

  statement {
    sid = "snowflakeS3Actions"

    actions = var.iam_permissions

    resources = [
      "arn:aws:s3:::${local.s3_bucket_and_key}"
    ]
  }

  statement {
    sid = "snowflakeListS3"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}"
    ]
  }
}

resource "aws_iam_role_policy" "storage_integration_policy" {
  name   = "${local.formatted_iam_name}-bucket-storage-integration-policy"
  policy = data.aws_iam_policy_document.storage_integration_policy_document.json
  role   = aws_iam_role.storage_integration_role.id
}
