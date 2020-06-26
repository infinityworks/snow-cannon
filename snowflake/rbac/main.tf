terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "snowflake" {
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SECURITYADMIN"
}
