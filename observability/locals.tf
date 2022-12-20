locals {
  config = module.config.entries
}

locals {
  project_name = module.config.entries.main.project_name
}

locals {
  env_formatted_lower = module.config.entries.env_formatted.lower
}
