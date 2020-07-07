terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "aws" {
  alias   = "aws"
  region  = var.region
  version = "~> 2.39"
}

provider "snowflake" {
  alias   = "snowflake"
  account = "aq70698"
  region  = "eu-west-1"
  role    = "ACCOUNTADMIN"
}
