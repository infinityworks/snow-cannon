module "example_pipe" {
  source         = "../../../modules/snowpipe-module/"
  s3_bucket_name = "iw-snowflake-demo-data-lake-${local.formatted_env}"
  s3_path        = "demo-transactions"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
