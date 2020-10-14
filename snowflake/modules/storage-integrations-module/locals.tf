locals {
  formatted_iam_name = lower(replace(replace(var.s3_path, "_", "-"), "/", "-"))
}
