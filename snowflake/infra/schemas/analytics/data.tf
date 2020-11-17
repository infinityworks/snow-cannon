data "terraform_remote_state" "databases" {
  backend = "s3"
  config = {
    bucket = "iw-demo-remote-state"
    key    = "env:/${local.env}/snowflake/infra/databases/terraform.tfstate"
    region = module.config.entries.providers.aws_region
  }
}
