data "terraform_remote_state" "snowflake_integration" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/integrations/terraform.tfstate"
    region = "eu-west-2"
  }
}
