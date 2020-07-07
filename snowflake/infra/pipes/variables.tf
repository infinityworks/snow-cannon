variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "snowpipe_table" {
  type        = string
  description = "The tabl which Snowpipe will copy data into"
}

variable "s3_external_stage" {
  type        = string
  description = "The external stage Snowflake points to"
}
