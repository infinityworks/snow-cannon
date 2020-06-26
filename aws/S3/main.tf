terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "aws" {
  region  = var.region
  version = "~> 2.39"
}
