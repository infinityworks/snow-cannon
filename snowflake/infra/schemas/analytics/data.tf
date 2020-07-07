data "terraform_remote_state" "snowpipe_database" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/databases/terraform.tfstate"
    region = "eu-west-2"
  }
}
