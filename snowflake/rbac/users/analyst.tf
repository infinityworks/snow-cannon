resource "snowflake_user" "user_ANALYST" {
  name                 = "ANALYST"
  login_name           = "ANALYST"
  default_role         = "PUBLIC"
  password             = "replace"
  must_change_password = "true"
  comment              = "Example user"
}
