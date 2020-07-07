variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "is_live" {
  type        = bool
  description = "boolean that shows if a resource is live i.e. being used in production. For budgetting purposes."
}
