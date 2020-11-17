data "terraform_remote_state" "user_info" {
  backend = "s3"
  config = {
    bucket = "iw-snowflake-demo-remote-state"
    key    = "env:/${local.env}/snowflake/rbac/users/terraform.tfstate"
    region = "eu-west-2"
  }
}
