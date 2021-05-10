locals {
  workspace_name = var.workspace_name != null ? var.workspace_name : terraform.workspace
}

locals {
  variables = local.environment[terraform.workspace]
}

locals {
  project_name = "snow-cannon"
}

locals {
  env_formatted_lower = replace(replace(lower(local.variables.name), "_", "-"), "/", "-")
}

locals {
  env_formatted_upper = replace(replace(upper(local.variables.name), "-", "_"), "/", "_")
}
