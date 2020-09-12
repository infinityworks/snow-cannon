terraform {
  required_version = ">= 0.12.29"

  backend "s3" {
  }
}

provider "snowflake" {
  account = var.snowflake_account
  region  = var.snowflake_region
  role    = "SYSADMIN"
}
