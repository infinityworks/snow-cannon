provider "snowflake" {
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}
provider "snowflake" {
  alias   = "security"
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SECURITYADMIN"
}

provider "snowflake" {
  alias   = "systems"
  account = "infinityworkspartner"
  region  = "eu-west-1"
  role    = "SYSADMIN"
}
