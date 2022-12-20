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

variable "filter_suffix" {
  default = ""
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

variable "file_format" {
  type        = string
  description = "The file format to be consumed"
  default     = "JSON"
}

variable "record_delimiter" {
  default = ""
}

variable "field_delimiter" {
  default = ""
}

variable "permissions_boundary" {
  description = "The IAM role permission boundary"
  default     = null
}

variable "path" {
  description = "IAM role path"
  default     = null
}

variable "skip_header" {
  type        = number
  default     = 0
  description = "The number of rows to skip if file type is csv"
}

variable "date_format" {
  type        = string
  default     = ""
  description = "The ingested file date format"
}

variable "validate_utf8" {
  type        = bool
  default     = true
  description = "validates utf8 encoding of file"
}

variable "error_integration" {
  type        = string
  description = "validates utf8 encoding of file"
}
