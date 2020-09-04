terraform {
  required_version = ">= 0.13"

  backend "s3" {
  }

  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.15.0"
    }
  }
}

provider "snowflake" {
  account = "yr26953"
  region  = "eu-west-1"
  role    = "SECURITYADMIN"
}
