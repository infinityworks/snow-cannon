data "aws_caller_identity" "current" {}

locals {
  formatted_s3_path = upper(replace(replace(var.s3_path, "-", "_"), "/", "_"))
  s3_bucket_and_key = "${var.has_key == false ? join("/", [var.s3_bucket_name, ""]) : join("/", [var.s3_bucket_name, var.s3_path, ""])}"
  iam_path          = "${var.path == null ? "" : join(var.path, "/")}"
}

resource "snowflake_storage_integration" "storage_integration" {
  name                      = "${local.formatted_s3_path}_DATA_STORAGE_INTEGRATION"
  type                      = var.type
  storage_provider          = "S3"
  storage_allowed_locations = ["S3://${local.s3_bucket_and_key}"]
  storage_aws_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iam_path}${var.storage_integration_IAM_role_name}"
  enabled                   = "true"
  comment                   = "storage integration for s3 key ${var.s3_path} in the external aws account's s3 bucket: ${var.s3_bucket_name}"
  lifecycle {
    ignore_changes = [type]
  }
}
