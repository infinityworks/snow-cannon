data "terraform_remote_state" "data_lake" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "persistence/s3/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "snowpipe_database" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/databases/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "snowflake_integration" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/integrations/terraform.tfstate"
    region = "eu-west-2"
  }
}
