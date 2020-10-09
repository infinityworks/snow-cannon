data "terraform_remote_state" "role_info" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "env:/${local.env}/snowflake/rbac/roles/terraform.tfstate"
    region = module.config.entries.providers.aws_region
  }
}
