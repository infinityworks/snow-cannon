locals {
  formatted_iam_name = lower(replace(replace(var.s3_path, "_", "-"), "/", "-"))
}

module "create_storage_integration" {
  source                            = "./storage-integrations-base/"
  s3_bucket_name                    = var.s3_bucket_name
  s3_path                           = var.s3_path
  has_key                           = var.has_key
  storage_integration_IAM_role_name = "${local.formatted_iam_name}-snowflake-storage-integration-role"
}

module "create_aws_iam_role" {
  source                                    = "../../../../aws/modules/iam-module/"
  s3_bucket_name                            = var.s3_bucket_name
  s3_path                                   = var.s3_path
  has_key                                   = var.has_key
  iam_permissions                           = var.iam_permissions
  permissions_boundary                      = var.permissions_boundary
  path                                      = var.path
  snowflake_storage_integration_user_arn    = module.create_storage_integration.storage_integration_snowflake_arn
  snowflake_storage_integration_external_id = module.create_storage_integration.storage_integration_external_id
}
