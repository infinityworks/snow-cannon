terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "snowflake" {
  account = "aq70698"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}

module "rbac" {
  source = "../../rbac"
}