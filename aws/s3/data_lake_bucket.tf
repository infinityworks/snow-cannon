resource "aws_s3_bucket" "data_lake" {
  bucket        = "${local.project_name}-data-lake-${local.config.env_formatted.lower}"
  force_destroy = true
  tags = {
    Project     = local.project_name
    Environment = local.config.main.env
    Description = "Data ingestion bucket"
  }
}

resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block_public_access_to_terraform_state" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls   = true
  block_public_policy = true
}
