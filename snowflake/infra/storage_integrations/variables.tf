variable "project" {
  type        = string
  description = "The project to which the resource belongs"
}

variable "external_AWS_account_id" {
  type        = string
  description = "The account ID of the external AWS account you wish to connect to"
}

variable "storage_integration_IAM_role_name" {
  type        = string
  description = "Name of the IAM role in the external account which gives access to the target S3 bucket"
}
