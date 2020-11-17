variable "workspace_name" {
  # (https://github.com/hashicorp/terraform/issues/22802)"
  default     = null
  description = "The actual name of the cloud workspace must be passed in when running inside terraform cloud. This variable should only be set within a workspace defined within terraform cloud."
  type        = string
}

variable "project_name" {
  type        = string
  default     = "iw-demo"
  description = "The project to which the resource belongs"
}
