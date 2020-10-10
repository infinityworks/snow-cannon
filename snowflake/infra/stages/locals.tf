locals {
  env = module.config.entries.main.env
}

locals {
  formatted_env = lower(module.config.entries.main.env)
}
