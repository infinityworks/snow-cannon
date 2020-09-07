resource "aws_dynamodb_table" "lock-table" {
  name         = "${var.project}-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Description = "Terraform lock table for Snowflake deployments"
    Environment = var.env
    Owner       = ""
  }
}
