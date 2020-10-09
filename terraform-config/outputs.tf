output "entries" {
  value = {
    main = {
      project_name = var.project_name
      group_name   = local.environment[terraform.workspace].group_name
      env          = local.environment[terraform.workspace].name
    }

    backend = {
      state_bucket_name = local.state_bucket_name
      lock_table_name   = local.lock_table_name
      workspace_name    = local.workspace_name
    }

    providers = {
      aws_account       = local.environment[terraform.workspace].aws_account.id
      aws_region        = local.environment[terraform.workspace].aws_account.region
      snowflake_account = local.environment[terraform.workspace].snowflake_account.id
      snowflake_region  = local.environment[terraform.workspace].snowflake_account.region
    }

  }
}
