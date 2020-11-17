terraform {
  required_version = ">= 0.13.2"

  backend "s3" {
    profile        = "aws-dev"
    bucket         = "iw-snowflake-demo-remote-state"
    dynamodb_table = "iw-snowflake-demo-lock-table"
    key            = "snowflake/infra/databases/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }

  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.17.1"
    }
  }
}
