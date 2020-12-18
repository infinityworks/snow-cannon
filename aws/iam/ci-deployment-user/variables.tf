variable "workspace_name" {
  # (https://github.com/hashicorp/terraform/issues/22802)"
  default     = null
  description = "The actual name of the cloud workspace must be passed in when running inside terraform cloud. This variable should only be set within a workspace defined within terraform cloud."
  type        = string
}

variable "permissions_boundary" {
  description = "The IAM role permission boundary"
  default     = null
}

variable "path" {
  description = "IAM role path"
  default     = null
}

variable "owner" {
  description = "The owner of this resource"
  default     = ""
}
