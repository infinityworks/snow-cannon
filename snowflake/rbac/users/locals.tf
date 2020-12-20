locals {
  env = module.config.entries.main.env
}

locals {
  formatted_env_lower = lower(local.env)
}

locals {
  formatted_env_upper = upper(local.env)
}

locals {
  project_name = module.config.entries.main.project_name
}

locals {
  project_name_upper = replace(replace(upper(local.project_name), "-", "_"), "/", "_")
}
