resource "snowflake_role_grants" "grants_on_ACCOUNTADMIN" {
  role_name = "ACCOUNTADMIN"

  users = [
    data.terraform_remote_state.user_info.outputs.user_example_name,
  ]
}
