terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}


provider "snowflake" {
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}

module "databases" {
  source       = "../databases"
  project      = var.project
  s3_data_lake = var.s3_data_lake
}

module "analytics_schemas" {
  source       = "../schemas/analytics"
  project      = var.project
  s3_data_lake = var.s3_data_lake
}
