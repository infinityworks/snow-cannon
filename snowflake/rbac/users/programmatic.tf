resource "snowflake_user" "user_ci_deployment" {
  name                 = "CI_DEPLOYMENT"
  login_name           = "CI_DEPLOYMENT"
  default_role         = "SYSADMIN"
  password             = "replace"
  must_change_password = "true"
  comment              = "CI Deployment user for infra & rbac"
}
