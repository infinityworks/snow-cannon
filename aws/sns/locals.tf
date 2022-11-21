locals {
  config = module.config.entries
}

locals {
  project_name = module.config.entries.main.project_name
}
