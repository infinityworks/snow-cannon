data "terraform_remote_state" "transactions_export" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state"
    key    = "env:/${terraform.workspace}/snowflake/infra/stages/terraform.tfstate"
    region = module.config.entries.providers.aws_region
  }
}
