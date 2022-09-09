locals {
  environment = {
    dev = {
      name       = "dev"
      group_name = "nonprod"

      aws_account = {
        id      = "455073406672"
        region  = "eu-west-2"
        profile = "aws-dev"
      }

      snowflake_account = {
        id     = "infinityworkspartner"
        region = "eu-west-1"
      }
    }
    providers = {
      snowflake_version = "0.43.0"
      aws_version       = "~> 3.5.0"
    }
  }
}
