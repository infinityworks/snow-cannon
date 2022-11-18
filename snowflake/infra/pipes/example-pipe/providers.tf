module "config" {
  source         = "../../../../terraform-config"
  workspace_name = terraform.workspace
}

provider "snowflake" {
  account = module.config.entries.providers.snowflake_account
  region  = module.config.entries.providers.snowflake_region
  role    = "SYSADMIN"
}

provider "aws" {
  region = module.config.entries.providers.aws_region
}
