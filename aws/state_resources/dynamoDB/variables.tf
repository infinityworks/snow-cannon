variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "env" {
  type        = string
  description = "The environment a resource belongs to"
}
