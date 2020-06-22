provider "snowflake" {
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}

module "databases" {
  source = "../../databases"
}
