module "transactions_export" {
  source         = "../../modules/stages-module/"
  s3_bucket_name = "snow-cannon-data-lake-${local.config.env_formatted.lower}"
  s3_path        = "transactions-export"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
  iam_permissions = ["s3:GetObject",
    "s3:GetObjectVersion",
    "s3:PutObject",
  ]
}
