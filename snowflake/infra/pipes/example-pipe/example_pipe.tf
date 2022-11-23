module "example_pipe" {
  source         = "../../../modules/snowpipe-module/"
  s3_bucket_name = "snow-cannon-data-lake-${local.config.env_formatted.lower}"
  s3_path        = "transactions"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}

module "test_pipe_to_fail" {
  source           = "../../../modules/snowpipe-module/"
  s3_bucket_name   = "snow-cannon-data-lake-${local.config.env_formatted.lower}"
  s3_path          = "customers"
  database         = "ANALYTICS"
  schema           = "PUBLIC"
  file_format      = "CSV"
  field_delimiter  = "\t"
  record_delimiter = "\n"
  filter_suffix    = ".csv"
}
