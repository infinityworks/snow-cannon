output "storage_integration_name" {
  value = snowflake_storage_integration.data_lake_storage_integration.name
}

output "storage_integration_external_id" {
  value = snowflake_storage_integration.data_lake_storage_integration.storage_aws_external_id
}

output "storage_integration_snowflake_arn" {
  value = snowflake_storage_integration.data_lake_storage_integration.storage_aws_iam_user_arn
}

output "storage_integration_IAM_name" {
  value = var.storage_integration_IAM_role_name
}
