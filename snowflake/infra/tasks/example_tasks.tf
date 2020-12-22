module "export_transactions" {
  source          = "../../modules/tasks-export-module"
  name            = "EXPORT_TRANSACTIONS"
  external_stage  = data.terraform_remote_state.transactions_export.outputs.transactions_stage_name
  export_filename = "data.csv"
  database        = "ANALYTICS"
  schema          = "PUBLIC"
  table           = "TRANSACTIONS"
  columns         = "*"
  schedule        = "USING CRON 0 3 * * * UTC"
  warehouse       = "DEMO_WH"
  comment         = "Daily export of transaction data"
  enabled         = false
}
