data "terraform_remote_state" "databases" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "env:/${terraform.workspace}/snowflake/infra/databases/terraform.tfstate"
    region = module.config.entries.providers.aws_region
  }
}
