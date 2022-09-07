locals {
  formatted_s3_path = upper(replace(replace(var.s3_path, "-", "_"), "/", "_"))
  s3_bucket_and_key = var.has_key == false ? join("/", [var.s3_bucket_name, ""]) : join("/", [var.s3_bucket_name, var.s3_path, ""])
  iam_path          = var.path == null ? "" : join(var.path, "/")
}
