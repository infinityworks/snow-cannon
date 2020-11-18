resource "aws_s3_bucket" "data_lake" {
  bucket        = "${local.project_name}-data-lake-${local.formatted_env}"
  force_destroy = true
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Contact     = "Adam.Dewberry@infinityworks.com"
    Description = "Data ingestion bucket"
    Environment = local.env
    Project     = local.project_name
    Purpose     = "Infra used in demoing Snowflake quick deploments"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_to_data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls   = true
  block_public_policy = true
}
