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

variable "permissions_boundary" {
  description = "The IAM role permission boundary"
  default     = null
}

variable "path" {
  description = "IAM role path"
  default     = null
}

variable "iam_permissions" {
  description = "The IAM actions / permissions assigned to the policy document"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:GetObjectVersion",
  ]
}
