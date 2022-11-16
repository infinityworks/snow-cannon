module "config" {
  source         = "../../../terraform-config"
  workspace_name = terraform.workspace
}

provider "snowflake" {
  account = module.config.entries.providers.snowflake_account
  region  = module.config.entries.providers.snowflake_region
  role    = "SECURITYADMIN"
}

provider "aws" {
  profile = module.config.entries.providers.aws_profile
  region  = module.config.entries.providers.aws_region
  version = "~> 4.39.0"
}
