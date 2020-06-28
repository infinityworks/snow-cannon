resource "snowflake_storage_integration" "snowflake_storage_integration" {
  name                      = "S3_DATA_LAKE_STORAGE_INTEGRATION"
  type                      = "EXTERNAL_STAGE"
  storage_provider          = "S3"
  storage_allowed_locations = ["S3://${var.project}-data-lake/"]
  storage_aws_role_arn      = "arn:aws:iam::${var.external_AWS_account_id}:role/${var.storage_integration_IAM_role_name}"
  enabled                   = "true"
  comment                   = "ADEWERRY testing"
}
