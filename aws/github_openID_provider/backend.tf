terraform {
  required_version = ">= 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }

  backend "s3" {
    bucket         = "snow-cannon-remote-state"
    dynamodb_table = "snow-cannon-lock-table"
    key            = "aws/github-openID-provider/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }

}
