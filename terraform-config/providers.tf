locals {
  environment = {
    dev = {

      name       = "dev"
      group_name = "nonprod"

      aws_account = {
        id     = "455073406672"
        region = "eu-west-2"
      }

      snowflake_account = {
        id     = "infinityworkspartner"
        region = "eu-west-1"
      }
    }
  }
}
