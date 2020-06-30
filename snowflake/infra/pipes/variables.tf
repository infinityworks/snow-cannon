variable "database_analytics" {
  type        = string
  description = "Name for the database: database_analytics"
}

variable "snowpipe_table" {
  type        = string
  description = "The tabl which Snowpipe will copy data into"
}

variable "s3_external_stage" {
  type        = string
  description = "The external stage Snowflake points to"
}
