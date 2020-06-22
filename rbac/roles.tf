resource "snowflake_role" "role_BI_ANALYST" {
  provider = snowflake.security
  name     = "BI_ANALYST"
  comment  = "ADEWBERRY Testing"
}

resource "snowflake_role" "role_DATA_ANALYST" {
  provider = snowflake.security
  name     = "DATA_ANALYST"
  comment  = "ADEWBERRY Testing"
}

resource "snowflake_role_grants" "grants_on_role_DATA_ANALYST" {
  provider  = snowflake.security
  role_name = snowflake_role.role_DATA_ANALYST.name

  roles = [
    "${snowflake_role.role_BI_ANALYST.name}",
  ]

  users = [
    "${snowflake_user.user_ANALYST.name}",

  ]
}
