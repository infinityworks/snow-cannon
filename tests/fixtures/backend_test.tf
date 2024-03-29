terraform {
  required_version = ">= 1.3.4"

  backend "s3" {
    bucket         = "my-project-remote-state"
    dynamodb_table = "my-project-lock-table"
    key            = "snowflake/infra/warehouses/terraform.tfstate"
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
