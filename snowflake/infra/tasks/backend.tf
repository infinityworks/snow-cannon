terraform {
  required_version = ">= 1.3.4"

  backend "s3" {
    profile        = "aws-dev"
    bucket         = "snow-cannon-remote-state"
    dynamodb_table = "snow-cannon-lock-table"
    key            = "snowflake/infra/tasks/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.50.0"
    }
  }
}
