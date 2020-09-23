terraform {
  required_version = ">= 0.13.2"
  backend "s3" {}
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.15.0"
    }
  }
}

provider "snowflake" {
  account = var.snowflake_account
  region  = var.snowflake_region
  role    = "SYSADMIN"
}

provider "aws" {
  region  = var.aws_region
  version = "~> 3.5.0"
}

module "create_storage_integration" {
  source                            = "../modules/storage-integrations-module/storage-integrations-base/"
  s3_bucket_name                    = "snow-cannon-data-lake"
  s3_path                           = "to_ingest"
  storage_integration_IAM_role_name = "to-ingest-snowflake-storage-integration-role"
}


module "create_storage_integration_with_iam" {
  source         = "../modules/storage-integrations-module/"
  s3_bucket_name = "snow-cannon-data-lake"
  s3_path        = "to_get/sub_layer"
}
