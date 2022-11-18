locals {
  config = module.config.entries
}

locals {
  project_name = module.config.entries.main.project_name
}

locals {
  project_name_upper = replace(replace(upper(local.project_name), "-", "_"), "/", "_")
}
