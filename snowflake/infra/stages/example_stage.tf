module "stage_example" {
  source         = "../modules/stages-module/"
  s3_bucket_name = "snow-cannon-data-lake-${local.env}"
  s3_path        = "key2"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
