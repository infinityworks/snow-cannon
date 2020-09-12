resource "snowflake_role" "DATA_ANALYST" {
  name    = "DATA_ANALYST"
  comment = "A role used to access the analytics layer"
}

resource "snowflake_role_grants" "grants_on_role_DATA_ANALYST" {
  role_name = snowflake_role.DATA_ANALYST.name

  users = [
    data.terraform_remote_state.user_info.outputs.user_ANALYST_name,
  ]
}
