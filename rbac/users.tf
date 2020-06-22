resource "snowflake_user" "user_ANALYST" {
  provider             = snowflake.security
  name                 = "ANALYST"
  login_name           = "ANALYST"
  default_role         = "PUBLIC"
  password             = "replace"
  must_change_password = "true"
  comment              = "ADEWBERRY Testing"

}
