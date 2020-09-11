terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "aws" {
  region  = var.aws_region
  version = "~> 3.5.0"
}

module "example_iam_creation" {
  source                                    = "../modules/iam-module/"
  s3_bucket_name                            = "snow-cannon-data-lake"
  s3_path                                   = "to_ingest"
  snowflake_storage_integration_user_arn    = "arn:aws:iam::282654190546:user/1nyk-s-iess3910"
  snowflake_storage_integration_external_id = "INFINITYWORKSPARTNER_SFCRole=2_jPQ70/u/RACsHPmDpk1sENdulrI="
}
