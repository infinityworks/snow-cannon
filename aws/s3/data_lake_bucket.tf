resource "aws_s3_bucket" "data_lake" {
  bucket        = var.data_lake_bucket
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
    Project     = var.project
    Environment = var.env
    Description = "Data ingestion bucket"
    Owner       = "Snow Cannon"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_to_data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls   = true
  block_public_policy = true
}
