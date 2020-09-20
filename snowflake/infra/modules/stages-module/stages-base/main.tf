locals {
  formatted_s3_path = upper(replace(replace(var.s3_path, "-", "_"), "/", "_"))
  s3_bucket_and_key = "${var.has_key == false ? join("/", [var.s3_bucket_name, ""]) : join("/", [var.s3_bucket_name, var.s3_path, ""])}"
}

resource "snowflake_stage" "external" {
  name                = "${local.formatted_s3_path}_EXTERNAL_STAGE"
  database            = var.database
  schema              = var.schema
  url                 = "S3://${local.s3_bucket_and_key}"
  storage_integration = var.storage_integration
  comment             = "Stage which points to the ${var.s3_path} data in ${var.s3_bucket_name} bucket"
}
