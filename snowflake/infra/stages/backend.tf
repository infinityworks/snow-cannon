terraform {
  required_version = ">= 0.13.2"
  backend "s3" {
    profile        = "sts"
    bucket         = "snow-cannon-remote-state-dev"
    dynamodb_table = "snow-cannon-lock-table"
    key            = "snowflake/infra/stages/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.15.0"
    }
  }
}
