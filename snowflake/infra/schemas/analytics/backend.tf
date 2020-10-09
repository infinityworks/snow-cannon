terraform {
  required_version = ">= 0.13.2"

  backend "s3" {
    profile        = "aws-dev"
    bucket         = "snow-cannon-remote-state"
    dynamodb_table = "snow-cannon-lock-table"
    key            = "snowflake/infra/schemas/analytics/terraform.tfstate"
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
