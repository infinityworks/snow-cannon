resource "snowflake_role" "BI_ANALYST" {
  name    = "BI_ANALYST"
  comment = "ADEWBERRY Testing"
}

resource "snowflake_role" "DATA_ANALYST" {
  name    = "DATA_ANALYST"
  comment = "ADEWBERRY Testing"
}

resource "snowflake_role_grants" "grants_on_role_DATA_ANALYST" {
  role_name = snowflake_role.DATA_ANALYST.name

  roles = [
    snowflake_role.BI_ANALYST.name,
  ]

  users = [
    snowflake_user.user_ANALYST.name,

  ]
}

output "role_BI_ANALYST" {
  value = snowflake_role.BI_ANALYST.name
}

output "role_DATA_ANALYST" {
  value = snowflake_role.DATA_ANALYST.name
}
