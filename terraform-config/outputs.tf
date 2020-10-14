output "entries" {
  value = {
    main = {
      project_name = var.project_name
      group_name   = local.variables.group_name
      env          = local.variables.name
    }

    backend = {
      state_bucket_name = local.state_bucket_name
      lock_table_name   = local.lock_table_name
      workspace_name    = local.workspace_name
    }

    providers = {
      aws_account = local.variables.aws_account.id
      aws_region  = local.variables.aws_account.region
      aws_profile = local.variables.aws_account.profile
      aws_version = local.environment.providers.aws_version

      snowflake_account = local.variables.snowflake_account.id
      snowflake_region  = local.variables.snowflake_account.region
      snowflake_version = local.environment.providers.snowflake_version
    }

  }
}
