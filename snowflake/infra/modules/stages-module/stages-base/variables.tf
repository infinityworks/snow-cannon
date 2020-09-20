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

variable "database" {
  type        = string
  description = "Name of the Snowflake database the resource is attached to"
}

variable "schema" {
  type        = string
  description = "Name of the Snowflake schema the resource is attached to"
  default     = "PUBLIC"
}

variable "storage_integration" {
  type        = string
  description = "The storage integration name used to authenticate the external stage"
}
