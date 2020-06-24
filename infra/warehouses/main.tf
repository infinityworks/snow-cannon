provider "snowflake" {
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}

module "rbac" {
  source = "../../rbac"
}