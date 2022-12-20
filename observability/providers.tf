module "config" {
  source         = "../terraform-config"
  workspace_name = terraform.workspace
}

provider "aws" {
  region = module.config.entries.providers.aws_region
  default_tags {
    tags = {
      Project     = local.project_name
      Environment = local.config.main.env
    }
  }
}
