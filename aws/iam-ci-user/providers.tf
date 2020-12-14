module "config" {
  source         = "../../terraform-config"
  workspace_name = terraform.workspace
}

provider "aws" {
  profile = module.config.entries.providers.aws_profile
  region  = module.config.entries.providers.aws_region
  version = "~> 3.5.0"
}
