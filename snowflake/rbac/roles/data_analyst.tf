resource "snowflake_role" "data_analyst" {
  name    = "${local.project_name_upper}_DATA_ANALYST"
  comment = "A role used to access the analytics layer"
}

resource "snowflake_role_grants" "grants_on_role_data_analyst" {
  role_name = snowflake_role.data_analyst.name

  users = [
    data.terraform_remote_state.user_info.outputs.user_analyst_name,
  ]
}
