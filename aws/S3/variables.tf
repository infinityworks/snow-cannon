variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "data_lake_bucket" {
  type        = string
  description = "S3 data lake bucket name"
}

variable "snowpipe_queue_arn" {
  type        = string
  description = "Snowpipe SQS arn used to push event notifications to"
}
