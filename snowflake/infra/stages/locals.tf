locals {
  env = module.config.entries.main.env
}

locals {
  formatted_env_lower = lower(local.env)
}
