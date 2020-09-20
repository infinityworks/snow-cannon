data "terraform_remote_state" "databases" {
  backend = "s3"
  config = {
    bucket = "snow-cannon-remote-state-${var.env}"
    key    = "snowflake/infra/databases/terraform.tfstate"
    region = var.aws_region
  }
}
