terraform {
  required_version = ">= 0.13"

  backend "s3" {
  }
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.39"
}
