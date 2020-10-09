module "config" {
  source         = "../../../terraform-config"
  workspace_name = terraform.workspace
}

provider "snowflake" {
  account = module.config.entries.providers.snowflake_account
  region  = module.config.entries.providers.snowflake_region
  role    = "SYSADMIN"
}

provider "aws" {
  region  = module.config.entries.providers.aws_region
  profile = module.config.entries.providers.aws_profile
  version = "~> 3.5.0"
}

module "stage_example" {
  source         = "../modules/stages-module/"
  s3_bucket_name = "snow-cannon-data-lake-${local.env}"
  s3_path        = "key2"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
