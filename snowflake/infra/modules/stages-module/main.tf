terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.15.0"
    }
  }
  backend "s3" {
  }
}

module "create_storage_integration" {
  source               = "../storage-integrations-module/"
  s3_bucket_name       = var.s3_bucket_name
  s3_path              = var.s3_path
  has_key              = var.has_key
  iam_permissions      = var.iam_permissions
  permissions_boundary = var.permissions_boundary
  path                 = var.path
}

module "create_stage" {
  source              = "./stages-base/"
  s3_bucket_name      = var.s3_bucket_name
  s3_path             = var.s3_path
  has_key             = var.has_key
  storage_integration = module.create_storage_integration.storage_integration_name
  database            = var.database
  schema              = var.schema
}
