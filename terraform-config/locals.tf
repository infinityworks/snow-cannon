locals {
  workspace_name = var.workspace_name != null ? var.workspace_name : terraform.workspace
}

locals {
  variables = local.environment[terraform.workspace]
}

locals {
  project_name = "snow- cannon"
}
