resource "snowflake_user" "user_ci_deployment" {
  name                 = "${local.project_name_upper}_CI_DEPLOYMENT"
  login_name           = "${local.project_name_upper}_CI_DEPLOYMENT"
  default_role         = "SYSADMIN"
  password             = "replace"
  must_change_password = "true"
  comment              = "CI Deployment user for infra & rbac"
}
