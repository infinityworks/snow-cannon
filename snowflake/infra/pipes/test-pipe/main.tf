terraform {
  required_version = ">= 0.13.2"
  backend "s3" {}
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.15.0"
    }
  }
}

provider "snowflake" {
  account = var.snowflake_account
  region  = var.snowflake_region
  role    = "SYSADMIN"
}

provider "aws" {
  region  = var.aws_region
  version = "~> 3.5.0"
}

module "test_pipe" {
  source         = "../../modules/snowpipe-module/"
  s3_bucket_name = "snow-cannon-data-lake-${lower(var.env)}"
  s3_path        = "key3"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
