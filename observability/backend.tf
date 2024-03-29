terraform {
  required_version = ">= 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.50.0"
    }
  }

  backend "s3" {
    bucket         = "snow-cannon-remote-state"
    dynamodb_table = "snow-cannon-lock-table"
    key            = "observability/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}
