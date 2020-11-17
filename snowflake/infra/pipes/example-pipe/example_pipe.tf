module "example_pipe" {
  source         = "../../../modules/snowpipe-module/"
  s3_bucket_name = "iw-demo-data-lake-${local.formatted_env}"
  s3_path        = "transactions"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
