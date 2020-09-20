terraform {
  required_version = ">= 0.12"

  backend "s3" {
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
  s3_path        = "sub1"
  database       = "ANALYTICS"
  schema         = "PUBLIC"
}
