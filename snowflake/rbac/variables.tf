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
