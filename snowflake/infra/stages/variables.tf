variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "s3_data_lake" {
  type        = string
  description = "The S3 bucket used to connect to Snowpipe"
}

variable "database_analytics" {
  type        = string
  description = "Name for the database: database_analytics"
}
