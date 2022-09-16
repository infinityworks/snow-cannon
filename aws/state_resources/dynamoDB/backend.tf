terraform {
  required_version = ">= 1.2.8"

  backend "s3" {
    profile = "aws-dev"
    bucket  = "snow-cannon-remote-state"
    key     = "aws/state-resources/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.43.0"
    }
  }
}
