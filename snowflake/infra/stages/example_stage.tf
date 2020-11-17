module "stage_example" {
  source         = "../../modules/stages-module/"
  s3_bucket_name = "iw-demo-data-lake-${local.formatted_env}"
  s3_path        = "EXAMPLE_STAGE"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
  iam_permissions = ["s3:GetObject",
    "s3:GetObjectVersion",
    "s3:PutObject",
  ]
}
