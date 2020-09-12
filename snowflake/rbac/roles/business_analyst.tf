resource "snowflake_role" "BI_ANALYST" {
  name    = "BI_ANALYST"
  comment = "A role used to access the BI schemas"
}

resource "snowflake_role_grants" "grants_on_role_BI_ANALYST" {
  role_name = snowflake_role.BI_ANALYST.name

  users = [
    data.terraform_remote_state.user_info.outputs.user_ANALYST_name,
  ]
}
