data "terraform_remote_state" "user_info" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "env:/${terraform.workspace}/snowflake/rbac/users/terraform.tfstate"
    region = "eu-west-2"
  }
}
