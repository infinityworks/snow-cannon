resource "snowflake_user" "user_ANALYST" {
  provider             = snowflake.security
  name                 = "ANALYST"
  login_name           = "ANALYST"
  default_role         = "IWDEMO"
  must_change_password = "true"
  comment              = "ADEWBERRY Testing"

}
