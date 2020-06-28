variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "s3_data_lake" {
  type        = string
  description = "The S3 bucket used to connect to Snowpipe"
}

variable "user_ANALYST" {
  type        = string
  description = "Username for the user: ANALYST"
}

variable "role_BI_ANALYST" {
  type        = string
  description = "Name for the role: BI_ANALYST"
}

variable "role_DATA_ANALYST" {
  type        = string
  description = "Name for the role: DATA_ANALYST"
}

variable "database_analytics" {
  type        = string
  description = "Name for the database: database_analytics"
}

variable "schema_db_analytics_marketing" {
  type        = string
  description = "Name for the schema: Analytics/Marketing"
}

variable "external_AWS_account_id" {
  type        = string
  description = "The account ID of the external AWS account you wish to connect to"
}

variable "storage_integration_IAM_role_name" {
  type        = string
  description = "Name of the IAM role in the external account which gives access to the target S3 bucket"
}
