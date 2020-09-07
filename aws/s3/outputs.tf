output "project_name" {
  value = var.project
}

output "data_lake_id" {
  value = aws_s3_bucket.data_lake.id
}

output "data_lake_arn" {
  value = aws_s3_bucket.data_lake.arn
}

output "data_lake_name" {
  value = aws_s3_bucket.data_lake.bucket
}
