resource "aws_dynamodb_table" "lock-table" {
  name         = "${local.project_name}-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Contact     = "Adam.Dewberry@infinityworks.com"
    Description = "Terraform lock table for Snowflake deployments"
    Environment = local.env
    Project     = local.project_name
    Purpose     = "Infra used in demoing Snowflake quick deploments"
  }
}
