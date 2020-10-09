module "stage_example" {
  source         = "../modules/stages-module/"
<<<<<<< HEAD
  s3_bucket_name = "snow-cannon-data-lake-${local.formatted_env}"
=======
  s3_bucket_name = "snow-cannon-data-lake-${local.env}"
>>>>>>> Separate proviers and example stage
  s3_path        = "key2"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
