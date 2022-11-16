locals {
  environment = {
    dev = {
      name       = "dev"
      group_name = "nonprod"

      aws_account = {
        id      = "054663422011"
        region  = "eu-west-2"
        profile = "aws-dev"
      }

      snowflake_account = {
        id     = "infinityworkspartner"
        region = "eu-west-1"
      }
    }
    providers = {
      snowflake_version = "0.50.0"
      aws_version       = "~> 4.39.0"
    }
  }
}
