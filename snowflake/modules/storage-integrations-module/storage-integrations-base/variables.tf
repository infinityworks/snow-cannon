variable "s3_path" {
  type        = string
  description = "Name of the data source in the target S3 bucket"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the event data bucket in the external account which we will ingest data from"
}

variable "has_key" {
  type        = bool
  default     = true
  description = "if 'has_key' s3_path will resolve to bucket/s3_path else bucket"
}

variable "path" {
  description = "IAM role path"
  default     = null
}

variable "storage_integration_IAM_role_name" {
  type        = string
  description = "Name of the IAM role in the external AWS account which gives access to the target S3 bucket"
}

variable "type" {
  type        = string
  description = "The type of snowflake stage being created"
  default     = "EXTERNAL_STAGE"
}
