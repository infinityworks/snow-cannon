locals {
  env = module.config.entries.main.env
}

locals {
  formatted_env = lower(module.config.entries.main.env)
}

locals {
  project_name = module.config.entries.main.project_name
}
