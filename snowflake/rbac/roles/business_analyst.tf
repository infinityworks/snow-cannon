resource "snowflake_role" "bi_analyst" {
  name    = "${local.project_name_upper}_BI_ANALYST"
  comment = "A role used to access the BI schemas"
}

resource "snowflake_role_grants" "grants_on_role_bi_analyst" {
  role_name = snowflake_role.bi_analyst.name

  users = [
    data.terraform_remote_state.user_info.outputs.user_analyst_name,
  ]
}
