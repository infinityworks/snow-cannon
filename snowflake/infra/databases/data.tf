data "terraform_remote_state" "role_info" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "snowflake/rbac/roles/terraform.tfstate"
    region = "eu-west-2"
  }
}
