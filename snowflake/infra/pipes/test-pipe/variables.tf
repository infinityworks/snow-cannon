variable "env" {
  type        = string
  description = "The environment a resource belongs to"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "snowflake_region" {
  type        = string
  description = "Snowflake Region"
  default     = "eu-west-1"
}

variable "snowflake_account" {
  type        = string
  description = "AWS Account Id"
  default     = "infinityworkspartner"
}
