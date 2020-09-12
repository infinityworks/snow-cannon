terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = var.aws_region
  version = "~> 3.5.0"
}
