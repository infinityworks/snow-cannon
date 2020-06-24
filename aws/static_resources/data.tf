data "terraform_remote_state" "data_lake" {
  backend = "s3"
  config = {
    bucket = "${var.project}-remote-state"
    key    = "persistence/s3/terraform.tfstate"
    region = "eu-west-2"
  }
}
