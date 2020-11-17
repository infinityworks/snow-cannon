resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.project_name}-remote-state"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Bucket to store the Terraform remote state files"
    Purpose     = "Infra used in demoing Snowflake quick deploments"
    Environment = local.env
    Project     = local.project_name
    Owner       = "Adam Dewberry & Rich Allen"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_to_terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
}
