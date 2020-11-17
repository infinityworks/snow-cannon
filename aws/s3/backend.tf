terraform {
  required_version = ">= 0.13.2"

  backend "s3" {
    profile        = "aws-dev"
    bucket         = "iw-demo-remote-state"
    dynamodb_table = "iw-demo-lock-table"
    key            = "aws/s3/terraform.tfstate"
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
