data "terraform_remote_state" "user_info" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/rbac/users/terraform.tfstate"
    region = "eu-west-2"
  }
}
