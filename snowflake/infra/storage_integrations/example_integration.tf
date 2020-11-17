module "create_storage_integration_with_iam" {
  source         = "../../modules/storage-integrations-module/"
  s3_bucket_name = "iw-snowflake-demo-data-lake-${local.formatted_env}"
  s3_path        = "example-integration"
}

module "create_storage_integration" {
  source                            = "../../modules/storage-integrations-module/storage-integrations-base/"
  s3_bucket_name                    = "iw-snowflake-demo-data-lake-${local.formatted_env}"
  s3_path                           = "example-integration-2"
  storage_integration_IAM_role_name = "to-ingest-snowflake-storage-integration-role"
}
