variable "s3_path" {
  type        = string
  description = "Name of the key / data source in the target s3 bucket"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the s3 bucket in the aws account which we will consume data from"
}

variable "has_key" {
  type        = bool
  default     = true
  description = "An identifier to indicate if we will consume directly from the s3 bucket or a key within. If 'has_key' = true,  s3_path will resolve to `bucket/s3_path` else `bucket`"
}

variable "permissions_boundary" {
  description = "The IAM role permission boundary"
  default     = null
}

variable "path" {
  description = "IAM role path"
  default     = null
}

variable "iam_permissions" {
  description = "The IAM actions / permissions assigned to the policy document"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:GetObjectVersion",
  ]
}

variable "snowflake_storage_integration_external_id" {
  description = "ID provided by the Snowflake external storage integration"
}

variable "snowflake_storage_integration_user_arn" {
  description = "The user ARN provided by the snowflake storage integration"
}

variable "owner" {
  description = "The owner of this resource"
  default     = ""
}
