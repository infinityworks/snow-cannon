resource "snowflake_user" "analyst" {
  name                 = "${local.project_name_upper}_ANALYST"
  login_name           = "${local.project_name_upper}_ANALYST"
  default_role         = "PUBLIC"
  password             = "replace"
  must_change_password = "true"
  comment              = "Example user"
}
