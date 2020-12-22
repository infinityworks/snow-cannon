output "debug" {
  value = {
    config = module.config.entries
  }
}

output "transactions_stage_name" {
  value = module.transactions_export.external_stage_name
}
