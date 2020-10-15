module "example_pipe" {
  source         = "../../../modules/snowpipe-module/"
  s3_bucket_name = "snow-cannon-data-lake-${local.formatted_env}"
  s3_path        = "transactions"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
