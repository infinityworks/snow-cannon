locals {
  s3_bucket_and_key  = var.has_key == false ? join("/", [var.s3_bucket_name, "*"]) : join("/", [var.s3_bucket_name, var.s3_path, "*"])
  formatted_iam_name = lower(replace(replace(var.s3_path, "_", "-"), "/", "-"))
}
