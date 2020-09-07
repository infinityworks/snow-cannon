terraform {
  required_version = ">= 0.13"

  backend "s3" {
  }
}

provider "aws" {
  region  = var.region
  version = "~> 2.39"
}