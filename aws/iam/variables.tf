variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "data_lake_suffix" {
  type        = string
  description = "S3 data lake bucket name suffix"
}

variable "is_live" {
  type        = bool
  description = "boolean that shows if a resource is live i.e. being used in production. For budgetting purposes."
}

variable "snowflake_external_id" {
  type        = string
  description = "The external Snowflake ID used to connect accounts"
}

variable "snowflake_storage_integration_role_arn" {
  type        = string
  description = "the arn of the role Snowflake will use to connect to our AWS account"
}
